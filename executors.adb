with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;
with Jobs; use Jobs;

package body Executors is

    protected body Executor is
       procedure Init(F : Buffer_Access; K : Integer; P : Thread_Pool_Access) is
       begin
          Futures := F;
          Keep_Alive_Time := K;
          Pool := P;
       end Init;
       
       --procedure get_callable_result(F : in Future; R : out Result_Access) is
       
       procedure Shutdown is
       begin
            Pool.Shutdown;
       end Shutdown;
       
       procedure Create
         (F : Future; Force : Boolean; Done : out Boolean)
       is
       begin
          Pool.Create(F, Force, Done,Futures);
       end Create;

        procedure Get_Pool(P : out Thread_Pool_Access) is 
        begin
            P := Pool;
        end Get_Pool;


    end Executor;

    function Submit(E : Executor_Access; C : Callable_Access) return Future is
        F : Future := new Protected_Future;
        Done : Boolean;
        P : Thread_Pool_Access;
    begin
        F.Set_Callable(C);
        F.Set_Completed(False);
        E.Get_Pool(P);
        E.Create(F, False, Done);
        if (Done) then
            return F;
        end if;
        return F;
    end submit;
end Executors;
