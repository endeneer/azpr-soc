import os, sys
import binascii

if (len(sys.argv) != 2):
    print("Usage: python azprbin2mif.py <program>.bin [depth width]")
else:
    bin_file = sys.argv[1]
    if os.path.exists(bin_file):
        bin_filename = os.path.basename(bin_file)
        bin_abspath = os.path.abspath(bin_file)
        dir_name = os.path.dirname(bin_abspath) 
        mif_abspath = os.path.join(dir_name, bin_filename) + '.mif'
        # print(mif_abspath)
        f_bin = open(bin_abspath, "rb")
        f_mif = open(mif_abspath, "w")
    else:
        print("Please make sure the specified .bin file exists.")
        exit(-1)

# (depth x width)
# width = how many bits per word
# depth = how many words
if (len(sys.argv) == 4):
    depth = sys.argv[2]
    width = sys.argv[3]
else:
    # default 
    depth = 256
    width = 32

# header
# print("WIDTH=%d;" % width)
# print("DEPTH=%d;" % depth)
# print()
# print("ADDRESS_RADIX=HEX;")
# print("DATA_RADIX=HEX;")
# print()
# print("CONTENT BEGIN")

f_mif.write("WIDTH=%d;\n" % width)
f_mif.write("DEPTH=%d;\n" % depth)
f_mif.write("\n")
f_mif.write("ADDRESS_RADIX=HEX;\n")
f_mif.write("DATA_RADIX=HEX;\n")
f_mif.write("\n")
f_mif.write("CONTENT BEGIN\n")

# content
byte = 0x00; 
word = ""
current_depth=0
byte_index = 0
# NOTE: while loop check for empty byte (EOF), not NULL character
while byte != b"":
    byte = f_bin.read(1)
    # print(i, "Ori:", byte)
    # print(i, "Now:", binascii.hexlify(byte).decode("ascii"))
    word += binascii.hexlify(byte).decode("ascii")
    if ((byte_index+1) % 4 == 0):
        # print('{current_depth:x} : {word} ;'.format(current_depth=current_depth, word=word))
        f_mif.write('{current_depth:x} : {word} ;\n'.format(current_depth=current_depth, word=word))
        current_depth += 1
        word = ""

    byte_index += 1
    # i now points to next byte's index

if (current_depth < depth):
    # if left one more to fill full depth, then don't use [] symbol
    # depth-1 due to zero indexing
    if (current_depth+1 == depth-1):
        # print('{} : {};'.format(depth-1, "".join(["00"]*(int(width/8)))))
        f_mif.write('{:x} : {};\n'.format(depth-1, "".join(["00"]*(int(width/8)))))
    else:
        # print('[{}..{}] : {};'.format(current_depth+1, depth-1, "".join(["00"]*(int(width/8)))))
        f_mif.write('[{:x}..{:x}] : {};\n'.format(current_depth, depth-1, "".join(["00"]*(int(width/8)))))

f_mif.write("END;\n")
print("Written to", mif_abspath)

# Cleanup
f_bin.close()
f_mif.close()

# Ignore
# I commented out this part because this should be the job of assembler
# padding with zero for non-aligned bytes to form a word
# print("Neded", 4-((i-1)%4), "more dummy bytes for padding")
# i-1 to get the final byte's index
# if ((byte_index-1)%4 != 0):
    # +1 because of using range()
    # for j in range(4-((byte_index-1)%4) + 1):
    #     word += "00"
# print(word)