@REM the mif in folder 1_11 is manually written, so no script here

azprasm\azprasm.exe 3_2\led.asm -o 3_2\led.bin
python azprbin2mif\azprbin2mif.py 3_2\led.bin

azprasm\azprasm.exe 3_3\serial.asm -o 3_3\serial.bin
python azprbin2mif\azprbin2mif.py 3_3\serial.bin
azprasm\azprasm.exe 3_3\serial_prog.asm -o 3_3\serial_prog.bin
python azprbin2mif\azprbin2mif.py 3_3\serial_prog.bin

azprasm\azprasm.exe 3_4\loader.asm -o 3_4\loader.bin
python azprbin2mif\azprbin2mif.py 3_4\loader.bin
azprasm\azprasm.exe 3_4\prog.asm -o 3_4\prog.bin
python azprbin2mif\azprbin2mif.py 3_4\prog.bin

azprasm\azprasm.exe 3_5\exception.asm -o 3_5\exception.bin
python azprbin2mif\azprbin2mif.py 3_5\exception.bin
azprasm\azprasm.exe 3_5\timer.asm -o 3_5\timer.bin
python azprbin2mif\azprbin2mif.py 3_5\timer.bin

azprasm\azprasm.exe 3_6\7seg_10.asm -o 3_6\7seg_10.bin
python azprbin2mif\azprbin2mif.py 3_6\7seg_10.bin
azprasm\azprasm.exe 3_6\7seg_counter.asm -o 3_6\7seg_counter.bin
python azprbin2mif\azprbin2mif.py 3_6\7seg_counter.bin

azprasm\azprasm.exe 3_7\kitchen_timer.asm -o 3_7\kitchen_timer.bin
python azprbin2mif\azprbin2mif.py 3_7\kitchen_timer.bin
