with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;
with Jobs; use Jobs;

package body Executors is

    protected body Executor is
        procedure Init(F : in Buffer_Access; K : in Integer; P : in Thread_Pool_Access) is
        begin
            Futures := F;
            Keep_Alive_Time := K;
            Pool := P;
        end Init;
       
        --procedure get_callable_result(F : in Future; R : out Result_Access) is

        Procedure executor_shutdown is
        begin
            Pool.Pool_Shutdown;
        end executor_shutdown;

    end Executor;

    function submit(E : Executor_Access; C : Callable_Access) return Future is
        f : Future;
        J : Job_Callable;
    begin
        f.Callable := C;
        f.Completed := False;
        if (E.Pool.Create(J,f,False)) then
            return f;
        end if;
        return f;
    end submit;
end Executors;
