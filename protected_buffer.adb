package body Protected_Buffer is

    protected body Shared_Items is 
        entry Get (I : out Integer) 
        when Size /= 0 is
        begin
            I := Buffer (First);
            First :=
            (First + 1) mod Length;
            Size := Size - 1;
        end Get;
        entry Set (I : in Integer)
        when Size /= Length is
        begin
            Last :=
            (Last + 1) mod Length;
            Buffer (Last) := I;
            Size := Size + 1;
        end Set;
    end Shared_Items;
end Protected_Buffer;


