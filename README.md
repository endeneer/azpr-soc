# About AZPR SoC
The main purpose of AZPR SoC is to teach about the design of a 5-stage pipelined CPU. However, since it's an SoC, it includes not only CPU, but also RAM, ROM, GPIO, timer, and UART, all of which are communicated via a customized bus (except for RAM).

It is developed for the Japanese textbook 《CPU自作入門》 （written by 水頭 一壽, 米澤 遼, and 藤田 裕士）, which is then translated by 赵谦 to the Chinese book 《CPU自制入门》。As of year 2023, there is no English version of the book, but if you're interested, you can try OCR and translate the text.

# About this repo
This repo is the implementation of AZPR SoC on Altera/Intel FPGA. Instead of using Xilinx tools and Icarus Verilog as used in the textbook, Quartus and ModelSim are used. 

Tested on Cyclone II EP2C5T144C8N FPGA development board, which is probably the world's cheapest FPGA.  
https://forum.hobbycomponents.com/viewtopic.php?f=88&t=2076

# Tutorial video
This video records demo as a proof that this repo is working and summarizes the essential parts of the design, hopefully it helps you to understand the book better.  
https://youtu.be/IetP5iAOws0

# Folder hierachy
- `1-hdl`: RTL code
- `2-tb`: Testbench
- `3-sim`: You should create a ModelSim project in this folder if and only if you want to do the simulation
- `4-synth`: Quartus project and FPGA design's output files (.pof, .sof)
- `5-asm`: .asm files, azprasm cross-assembler (only works on Windows) and python script to convert .bin to .mif.

# Things that needs to improve 
- The gpio.v should use 2-FF synchronizers against metastability
- Testbenches should be more rigorous to properly test each component
- Comments should be converted to English since not everyone knows Chinese/Japanese

# Links
《CPU自制入门》book:  
https://book.douban.com/subject/25780703/

Original AZPR SoC files:  
https://gihyo.jp/book/2012/978-4-7741-5338-4/support

This repo's RTL (1-hdl/ folder) is based on the RTL from zhangly/azpr_cpu (as it contains Chinese comment, but unfortunately my computer messed up the characters anyway):  
https://github.com/zhangly/azpr_cpu

Here is a repo with English comment:
https://github.com/jonsonxp/sea_azpr/tree/master/hw/rtl_original

Useful Cyclone II FPGA info:  
https://github.com/tocache/Altera-Cyclone-II-FPGA

The schematic for EP2C5T144C8N FPGA development board is in the repo too:  
https://github.com/tocache/Altera-Cyclone-II-FPGA/blob/master/Documentaci%C3%B3n/EP2C5T144-Altera-Cyclone-II-FPGA-Development-Board-Diagram.pdf

The EP2C5T144C8N FPGA development board has EPCS to store FPGA configuration (programmed using .pof via active serial mode). You may read more on active serial configuration here:   
https://www.intel.com/content/www/us/en/docs/programmable/683375/current/using-epcs-and-epcq-devices.html

If you can't find the Cyclone II EP2C5T144C8N FPGA development board, you may try the second cheapest FPGA development board I know (Cyclone IV EP4CE6E22C8):  
https://github.com/SlithyMatt/Altera-Cyclone-IV-board-V3.0

# License
As requested by book authors, the source code of AZPR SoC is only for non-commercial usage. You are free to modify and redistribute, but you must mention original authors, they are Mr. 水頭 一壽, Mr. 米澤 遼 and Mr. 藤田 裕士.