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
    
    procedure Get (B : Buffer_Access; E : out Element) is
    begin
       B.Get (E);
    end Get;
    
    procedure Remove (B : Buffer_Access; E: out Element) is
    begin
       select
          B.Get (E);
       else
          raise Empty_Buffer_Exception;
       end select;
    end Remove;
    
    procedure Remove (B : Buffer_Access; E: out Element; Done : out Boolean) is
    begin
       select
          B.Get (E);
          Done := True;
       else
          Done := False;
       end select;
    end Remove;
    
    procedure Poll (B : Buffer_Access; T : Time; E: out Element) is
    begin
       select 
          B.Get(E);
       or 
          delay until T;
          raise Empty_Buffer_Exception;
       end select;
    end Poll;
    
    procedure Poll (B : Buffer_Access; 
                    T : Time;
                    E : out Element;
                    Done : out Boolean)
    is
    begin
       select 
          B.Get(E);
          Done := True;
       or 
          delay until T;
          Done := False;
       end select;
    end Poll;
       
end Generic_Protected_Buffers;
