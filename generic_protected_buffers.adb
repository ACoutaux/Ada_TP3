package body Generic_Protected_Buffers is

    procedure Add (Items : Shared_Items_Access; Value : Integer) is
    begin
        select
            Items.Put (Value);
        else
            raise Full_Buffer_Exception;
        end select;
    end Add;
    
    procedure Offer (Items : Shared_Items_Access; Value : Integer; Deadline : Time) 
    is
    begin
       select 
          Items.Put (Value);
       or
          delay until Deadline;
          raise Full_Buffer_Exception;
       end select;
    end Offer;

end Generic_Protected_Buffers;