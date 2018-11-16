PROGRAM_NAME='RGBprg'


DEFINE_PROGRAM

for (kk=1;kk<=length_array(brRGBset);kk++){
    [dvTPrgb,brRGBset[kk][1]+1]=timeline_active(tmRGB[kk])
}