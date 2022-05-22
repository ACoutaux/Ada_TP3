package body Protected_Buffer is

    protected body Shared_Items is 
        entry Get (I : out Integer) 
        when true is
        begin
            I := Buffer (First);
            First :=
            (First + 1) mod Length;
            Size := Size - 1;
        end Get;
        entry Set (I : in Integer)
        when true is
        begin
            Last :=
            (Last + 1) mod Length;
            Buffer (Last) := I;
            Size := Size + 1;
        end Set;
        entry Get_size (I : out Natural) -- return current size of buffer
        when true is
        begin
            I:=size;
        end Get_size;
    end Shared_Items;
end Protected_Buffer;
