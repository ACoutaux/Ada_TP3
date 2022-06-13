with Future_Protected_Buffers;
use Future_Protected_Buffers;
with Ada.Text_IO; 
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

procedure main_tp5 is

    core_pool_size : Integer;
    max_pool_size : Integer;
    pool_size : Integer;
    keep_alive_time : Integer;
    period : Integer;
    job_table_size : Integer;
    My_File : File_Type;


begin

    Open(My_File, In_File, Name => "params_tp5.txt");
    Get(My_File, core_pool_size);
    Get(My_File,max_pool_size);
    Get(My_File,pool_size);
    Get(My_File,keep_alive_time);
    Get(My_File,period);
    Get(My_File,job_table_size);

end main_tp5;