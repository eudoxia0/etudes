package body One is
   function Solution return Natural is
   begin
      return Sum_Multiples_Until(1000);
   end Solution;

   function Sum_Multiples_Until(N: in Natural) return Natural is
      Sum : Natural := 0;
   begin
      for I in Natural range 0 .. N-1 loop
         if Is_Multiple(I) then
            Sum := Sum + I;
         end if;
      end loop;
      return Sum;
   end Sum_Multiples_Until;

   function Is_Multiple(N: in Natural) return Boolean is
   begin
      return Is_Multiple_3(N) or Is_Multiple_5(N);
   end Is_Multiple;

   function Is_Multiple_3(N: in Natural) return Boolean is
   begin
      return (N rem 3) = 0;
   end Is_Multiple_3;

   function Is_Multiple_5(N: in Natural) return Boolean is
   begin
      return (N rem 5) = 0;
   end Is_Multiple_5;
end One;
