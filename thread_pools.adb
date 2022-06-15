package body Thread_Pools is

    protected body Thread_Pool is
       procedure Init (C : in Integer; M : in Integer; S : in Integer) is
       begin
            Core_Pool_Size := C;
            Max_Pool_Size := M;
            Size := S;            
       end Init;
    end Thread_Pool;


    task body Pool_thread is
    begin
        accept Initialize (J : Job_Callable) do
            null;
        end Initialize;
    end Pool_thread;

end Thread_Pools;