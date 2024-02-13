#!/bin/sh

  
  FIFO_PATH="wob-fifo"
  #FIFO_PATH="/var/lib/misc/wob_fifo"

  BACKLIGHT_PATH="bl-path"
  #BACKLIGHT_PATH="/sys/class/backlight/amdgpu_bl0"

  read -a VAL_ARRAY <<< "val-array" 
  #VAL_ARRAY=( 0 1 2 4 8 16 32 64 128 255 )


  CUR_BRIGHT=$(<$BACKLIGHT_PATH/brightness)
  INC_BY=$1

  closest_index() {
    target=$1
    closest_index=0
    min_difference=$((target - ${2}))
 
    for num in "${@:2}"; do
        difference=$((target - num))
        if ((difference < 0)); then 
            difference=$((difference * -1))
        fi
          
        if ((difference < min_difference)); then
            min_difference=$difference
            closest_index=$((closest_index + 1))
        fi
    done  
    echo $closest_index
   }
   ((TAR_I= $(closest_index "$CUR_BRIGHT" "${VAL_ARRAY[@]}") + $INC_BY))

   
  if (($TAR_I >= 1 && $TAR_I <= ${#VAL_ARRAY[@]})); then
    echo "${VAL_ARRAY[TAR_I]}"> $BACKLIGHT_PATH/brightness
  fi

  echo "$(( 100 * ( TAR_I-1 ) / ( "${#VAL_ARRAY[@]}"-1 ) ))" > $FIFO_PATH

