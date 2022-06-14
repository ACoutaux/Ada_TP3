package body Thread_Pools is

    task body Pool_thread is
    begin
        accept Initialize (J : Job_Callable) do
            null;
        end Initialize;
    end Pool_thread;
end Thread_Pools;