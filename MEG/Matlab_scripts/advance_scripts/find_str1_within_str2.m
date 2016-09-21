function [index]=find_str1_within_str2(str_small,str_big)

 f=strcmp(str_big,str_small);
 index=find(f);

