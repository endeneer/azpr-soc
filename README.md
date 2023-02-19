# About AZPR SoC
The main purpose of AZPR SoC is to teach about the deisng of a 5-stage pipelined CPU. However, since it's an SoC, it includes not only CPU, but also RAM, ROM, GPIO, timer, and UART, all of which are communicated via a customized bus (except for RAM).

It is developed for the Japanese textbook 《CPU自作入門》 （written by 水頭 一壽, 米澤 遼, and 藤田 裕士）, which is then translated by 赵谦 to the Chinese book 《CPU自制入门》。

# About this repo
This repo is the implementation of AZPR SoC on Altera/Intel FPGA. Instead of using Xilinx tools and Icarus Verilog as used in the textbook, Quartus and ModelSim are used. 

Tested on Cyclone II EP2C5T144C8N, which is probably the world's cheapest FPGA.  
https://forum.hobbycomponents.com/viewtopic.php?f=88&t=2076

# Links
《CPU自制入门》book:  
https://book.douban.com/subject/25780703/

Original AZPR SoC files:  
https://gihyo.jp/book/2012/978-4-7741-5338-4/support

This repo's RTL is based on the RTL from zhangly/azpr_cpu (as it contains Chinese comment):  
https://github.com/zhangly/azpr_cpu

Useful Cyclone II FPGA documents:  
https://github.com/tocache/Altera-Cyclone-II-FPGA

If you can't find the Cyclone II EP2C5T144C8N FPGA development board, you may try the second cheapest FPGA development board I know (Cyclone IV EP4CE6E22C8):  
https://github.com/SlithyMatt/Altera-Cyclone-IV-board-V3.0

# License
As requested by book authors, the source code of AZPR SoC is only for non-commercial usage. You are free to modify and redistribute, but you must mention original authors, they are Mr. 水頭 一壽, Mr. 米澤 遼 and Mr. 藤田 裕士.