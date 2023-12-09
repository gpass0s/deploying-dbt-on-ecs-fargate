mkdir -p $package_output_dir;
if [ -f $requirements ]; then
  tmp_path=$package_output_dir/$package_output_name-requirements.txt
  cp $requirements $tmp_path
  export requirements=$(basename $tmp_path)
fi


cd $package_output_dir; package_output_dir="$PWD"

container_name=layer-builder-$package_output_name
image_name=public.ecr.aws/sam/build-$runtime:latest
internal_output_dir=/var/task/output_dir

echo image_name $image_name
echo package_output_dir $package_output_dir
echo requirements $requirements
echo container_name $container_name
echo internal_output_dir $internal_output_dir

docker image pull $image_name
docker container run \
--volume $package_output_dir:$internal_output_dir \
--name $container_name \
--env runtime=$runtime \
--env output_dir=$internal_output_dir \
--env file_name=$package_output_name \
--env requirements="$requirements" \
$image_name /bin/bash -c '

      TARGET=lambda_layer/python/lib/$runtime/site-packages/
      mkdir -p $TARGET

      if [ -f "$output_dir/$requirements" ]; then
        $runtime -m pip install -r "$output_dir/$requirements" -t $TARGET. -qqq --upgrade
      else
        $runtime -m pip install $requirements -t $TARGET. --upgrade -qqq
      fi

      cd lambda_layer/
      zip -r -q "$output_dir/$file_name.zip" *

      exit
'

docker container rm $container_name

#destination_file="$package_output_dir/$package_output_name.zip"
#
#if [ -f destination_file ]; then
#    echo "Target file generated: $destination_file"
#else
#    echo "Failed to generate file at: $destination_file"
#fi
#
