with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;

package body Executors is

    protected body Executor is
        procedure Init(F : in Buffer_Access; K : in Integer; P : in Thread_Pool_Access) is
        begin
            Futures := F;
            Keep_Alive_Time := K;
            Pool := P;
        end Init;
       
    end Executor;

    function submit(E : Executor; C : Callable_Access) return Future is
    f : Future; --non implementee / pour tester les specs
    begin
        return f;
    end submit;
end Executors;
