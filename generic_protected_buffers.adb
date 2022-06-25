package body Generic_Protected_Buffers is

    protected body G_Buffer is 
        entry Get (E : out Element; Done : out Boolean) 
        when Size > 0 is
        begin
            E := Buffer (First);
            First := (First + 1) mod Length;
            Size := Size - 1;
            Done := True;
        end Get;
        entry Put (E : in Element; Done : out Boolean)
        when Size < Length is
        begin
            Last := (Last + 1) mod Length;
            Buffer (Last) := E;
            Size := Size + 1;
            Done := True;
        end Put;
        procedure Reinit_Done(D : Boolean) is
        begin
            Done := D;
        end Reinit_Done;
    end G_Buffer;

end Generic_Protected_Buffers;