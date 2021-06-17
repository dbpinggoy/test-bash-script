#!/bin/bash


# Bash script that:
#     - Accepts a parameter that is a directory path
#     - Create a temporary directory under /tmp
#     - Copy all the files under the directory that match *.log, preserving that same directory structure
#     into the new temp directory
#     - For each file, in the directory, rename it to end in the file size.
#     - Compress the files as a .tar.gz call <yourusername>.tar.gz and email them to yourself
#     - Set the script permission as executable.


# only a test - creating my log directory (not the /var/log)
# for i in `seq 1 5`; do mkdir -p $i-test-log && cd $i-test-log && touch file$i.log && cd ..; done


# Accepts a parameter that is a directory path
param_path=$1
[[ -z "$param_path" ]] && { echo "Positional parameter 1 is empty" ; exit 1; }
echo "Enter a full directory path: $param_path"
echo "you have entered, $param_path"

# Create a temporary directory under /tmp
mkdir -p /tmp/my_temp_dir

# Copy all the files under the directory that match *.log, preserving that same directory structure into the new temp directory
for i in $(ls -1 -d */);
do
  file_check=$(ls $i)
  if [[ -n $file_check ]]; then
    mkdir -p /tmp/my_temp_dir/$i && \
    cd $i && \
    cp *.log /tmp/my_temp_dir/$i && \
    cd ..
  fi
done

# For each file, in the directory, rename it to end in the file size.
for x in $(ls -1 -d /tmp/my_temp_dir/*/)
do
  echo $x
  cd $x
    for f in *
    do
      suffix=$(ls -lh $f | awk '{print $5}')
      ls $f | xargs -I {} mv {} {}_$suffix
    done
  cd ..
done

# Compress the files as a .tar.gz call <yourusername>.tar.gz and email them to yourself
for x in $(ls -1 -d /tmp/my_temp_dir/*/)
do
  cd $x
  tar -cvzf $USER.tar.gz *
  echo "See attached" | mail -s "$USER.tar.gz" -A $USER.tar.gz db.pinggoy@gmail.com
  cd ..
done

# Set the script permission as executable.
chmod +x test_bash_script.sh
