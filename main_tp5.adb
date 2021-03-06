with Future_Protected_Buffers; use Future_Protected_Buffers;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Executors; use Executors;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;
with Jobs; use Jobs;
with Ada.Command_Line, Ada.Calendar;
use Ada.Command_Line, Ada.Calendar;

procedure Main_Tp5 is

    Core_Pool_Size : Integer;
    Max_Pool_Size : Integer;
    Blocking_Queue_Size : Integer;
    Keep_Alive_Time : Integer;
    Period : Integer;
    Job_Table_Size : Integer;
    Exec_time : Integer;

    My_File : File_Type;
    My_Executor : Executor_Access := new Executor;
    My_Thread_Pool : Thread_Pool_Access := new Thread_Pool;
    My_Buffer : Buffer_Access;
    Callable : Job_Callable_Access;
    F : Future;
    Start_Time : Time;

begin

    Open(My_File, In_File, Name => Argument(1));
    Get(My_File, Core_Pool_Size);
    Get(My_File, Max_Pool_Size);
    Get(My_File, Blocking_Queue_Size);
    Get(My_File, Keep_Alive_Time);
    Get(My_File, Period);
    Get(My_File, Job_Table_Size);


    My_Buffer := new G_Buffer(Blocking_Queue_Size);
    -- Init de Thread_Pool  
    My_Thread_Pool.Init(Core_Pool_Size, Max_Pool_Size, Duration(Keep_Alive_Time));
    My_Executor.Init(My_Buffer, My_Thread_Pool);

    Start_Time := Clock;
    -- Init des futures
    for i in 1..Job_Table_Size loop
        Callable := new Job_Callable;
        Get(My_File,Exec_time);
        Callable.Exec_Time := Duration(Exec_time);
        Callable.Period := Duration(Period);
        F := submit(My_Executor,Callable_Access(Callable),Start_Time);
    end loop;

    Delay(10.0);
    Shutdown (My_Executor);
end main_tp5;
