
%==========================================================================
function [W]=lvmread6chs(file_name,row_num_first)
%'%s%s%s%s' is the data types of [a1,a2,a3,a4](string)
[a1,a2,a3,a4,a5,a6]=textread(file_name,'%s%s%s%s%s%s');
a1=str2double(a1(row_num_first:end,1));
a2=str2double(a2(row_num_first:end,1));
a3=str2double(a3(row_num_first:end,1));
a4=str2double(a4(row_num_first:end,1));
a5=str2double(a5(row_num_first:end,1));
a6=str2double(a6(row_num_first:end,1));
% a7=str2double(a7(row_num_first:end,1));
% a1 = a1(row_num_first:row_num_first+num_rows-1,1);
% a2 = a2(row_num_first:row_num_first+num_rows-1,1);
% a3 = a3(row_num_first:row_num_first+num_rows-1,1);
% a4 = a4(row_num_first:row_num_first+num_rows-1,1);
% a5 = a5(row_num_first:row_num_first+num_rows-1,1);

W=[a1,a2,a3,a4,a5,a6];
%[a1,a2,a3,a4]=textread(file_name,'%f%f%f%f','headerlines',200);
%