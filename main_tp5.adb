with Future_Protected_Buffers; use Future_Protected_Buffers;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Executors; use Executors;
with Thread_Pools; use Thread_Pools;

procedure main_tp5 is

    Core_Pool_Size : Integer;
    Max_Pool_Size : Integer;
    Pool_Size : Integer;
    Keep_Alive_Time : Integer;
    Period : Integer;
    Job_Table_Size : Integer;
    Exec_Time : Integer;

    My_File : File_Type;

    My_Executor : Executor;
    My_Thread_Pool : Thread_Pool_Access;
    My_Buf : Buffer_Access;

begin

    Open(My_File, In_File, Name => "params_tp5.txt");
    Get(My_File, Core_Pool_Size);
    Get(My_File, Max_Pool_Size);
    Get(My_File, Pool_Size);
    Get(My_File, Keep_Alive_Time);
    Get(My_File, Period);
    Get(My_File, Job_Table_Size);

    -- Init de Thread_Pool  
    My_Thread_Pool.Init(Core_Pool_Size, Max_Pool_Size);
    My_Executor.Init(My_Buf, Keep_Alive_Time, My_Thread_Pool);

end main_tp5;
