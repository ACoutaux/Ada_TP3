package body Thread_Pools is

   protected body Thread_Pool is
      procedure Init (C : in Integer; M : in Integer) is
      begin
         Core_Pool_Size := C;
         Max_Pool_Size := M;
      end Init;

      procedure Create 
        (C : Callable_Access; F : Future; Force : Boolean; Done : out Boolean)
      is
         Thread : Pool_Thread_Access;
      begin
         Done := False;
         if (Size < Core_Pool_Size) or else
           (Force and then Size < Max_Pool_Size)
         then
            Thread := new Pool_Thread;
            Size := Size + 1;
            Done := True;
            Thread.Initialize(C);
         end if;
      end Create;

      procedure Shutdown is 
      begin
         Shutdown_Activated := True;
      end;

      procedure Remove is
      begin
         if (Size > Core_Pool_Size)
           or else (Shutdown_Activated)
         then
            Size := Size - 1;
         end if;
      end Remove;
   end Thread_Pool;

   task body Pool_thread is
   begin
      accept Initialize (C : Callable_Access) do
         null;
      end Initialize;
   end Pool_Thread;

end Thread_Pools;
