start=5
end=9

for ((i=start; i<=end; i++))
do
  f=$(printf '%*s' $(($i - $start + 1)) '' | tr ' ' '=')
  d=$(printf '%*s' $(($end - $i)) '' | tr ' ' ' ')
  printf "Running... [$f$d]"

  size=$(echo 2^$(($i + 1)) | bc)
  output=$(bend run src/convolution/5_all_pattern_matching.bend $i -s | grep "TIME: " | sed "s/- TIME: //")

  printf "\r%s\n" "Convolution of arrays size: $size - $output"
done