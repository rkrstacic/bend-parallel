if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <true|false>"
    exit 1
fi

if [ $1 = true ]; then
  echo "Parrallel execution"
else
  echo "Sequential execution"
fi

start=5
end=9

file=$(echo "src/convolution/5_1_all_pattern_matching_list_based.bend")
# file=$(echo "src/convolution/5_2_all_pattern_matching_tree_based.bend")

for ((i=start; i<=end; i++))
do
  f=$(printf '%*s' $(($i - $start + 1)) '' | tr ' ' '=')
  d=$(printf '%*s' $(($end - $i)) '' | tr ' ' ' ')
  printf "Running... [$f$d]"

  size=$(echo 2^$(($i + 1)) | bc)
  output=$(bend run$([ $1 = true ] && echo '-c' || echo '' ) $file $i -s | grep "TIME: " | sed "s/- TIME: //")

  printf "\r%s\n" "Convolution of arrays size: $size - $output"
done