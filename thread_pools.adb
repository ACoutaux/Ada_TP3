package body Thread_Pools is

    protected body Thread_Pool is
        procedure Init (C : in Integer; M : in Integer) is
        begin
            Core_Pool_Size := C;
            Max_Pool_Size := M;
        end Init;

        procedure Create (J : Job_Callable; F : Future; Force : Boolean) is
            done : Integer;
            thread : Pool_thread_Access;
        begin
            done := 0;

            if (Size < Core_Pool_Size) then
                thread := new Pool_thread;
                done := 1;
                size := size + 1;
            elsif (Force and Size < Max_Pool_Size) then
                thread := new Pool_thread;
                done := 1;
                size := size + 1;
            end if;
        end Create;

        procedure Pool_Shutdown is 
        begin
            Shutdown := True;
        end;

        procedure Remove is
            done : Integer;
        begin
            done := 1;
            if (Size > Core_Pool_Size) then
                Size := Size - 1;
            end if;

            if (Shutdown) then
                Size := Size - 1;
            end if;
        end Remove;
    end Thread_Pool;


    task body Pool_thread is
    begin
        accept Initialize (J : Job_Callable) do
            null;
        end Initialize;
    end Pool_thread;

end Thread_Pools;