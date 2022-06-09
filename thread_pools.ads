package Thread_Pools is
   
   type Thread_Pool is record
      Core_Pool_Size : Natural;
      Max_Pool_Size : Natural;
      Size : Natural;
   end record;

end Thread_Pools;
