
package body Protected_Buffer is

    protected body Shared_Items is 
        entry Get (I : out Integer) 
        when Size > 0 is
        begin
            I := Buffer (First);
            First := (First + 1) mod Length;
            Size := Size - 1;
        end Get;
        entry Put (I : in Integer)
        when Size < Length is
        begin
            Last := (Last + 1) mod Length;
            Buffer (Last) := I;
            Size := Size + 1;
        end Put;
    end Shared_Items;
    
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

    function Remove (Items : Shared_Items_Access) 
    return Integer
    is
    Value : Integer;
    begin
        select
            Items.Get (Value);
        else
            raise Empty_Buffer_Exception;
        end select;
        return Value;
    end Remove;

    function Poll (Items : Shared_Items_Access; Deadline : Time)
    return Integer
    is
    Value : Integer;
    begin
        select
            Items.Get (Value);
        or
            delay until Deadline;
            raise Empty_Buffer_Exception;
        end select;
        return Value;
    end Poll;
    
end Protected_Buffer;