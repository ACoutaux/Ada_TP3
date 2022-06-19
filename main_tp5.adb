with Future_Protected_Buffers; use Future_Protected_Buffers;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Executors; use Executors;
with Thread_Pools; use Thread_Pools;

procedure main_tp5 is

    core_pool_size : Integer;
    max_pool_size : Integer;
    pool_size : Integer;
    keep_alive_time : Integer;
    period : Integer;
    job_table_size : Integer;
    exec_time : Integer;

    My_File : File_Type;

    My_Executor : Executor;
    My_Thread_Pool : Thread_Pool_Access;
    My_Buf : Buffer_Access;



begin

    Open(My_File, In_File, Name => "params_tp5.txt");
    Get(My_File, core_pool_size);
    Get(My_File,max_pool_size);
    Get(My_File,pool_size);
    Get(My_File,keep_alive_time);
    Get(My_File,period);
    Get(My_File,job_table_size);

    --Init de Thread_Pool  
    My_Thread_Pool.Init(core_pool_size,max_pool_size);



    My_Executor.Init(My_Buf,keep_alive_time,My_Thread_Pool);



end main_tp5;