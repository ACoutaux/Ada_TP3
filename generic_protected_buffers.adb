package body Generic_Protected_Buffers is

    protected body G_Buffer is 
        entry Get (E : out Element) 
        when Size > 0 is
        begin
            E := Buffer (First);
            First := (First + 1) mod Length;
            Size := Size - 1;
        end Get;
        entry Put (E : in Element)
        when Size < Length is
        begin
            Last := (Last + 1) mod Length;
            Buffer (Last) := E;
            Size := Size + 1;
        end Put;
    end G_Buffer;

end Generic_Protected_Buffers;