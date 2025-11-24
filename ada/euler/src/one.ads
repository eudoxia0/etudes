package One is
   function Solution return Natural;
private
   function Sum_Multiples_Until(N: in Natural) return Natural;
   function Is_Multiple(N: in Natural) return Boolean;
   function Is_Multiple_3(N: in Natural) return Boolean;
   function Is_Multiple_5(N: in Natural) return Boolean;
end One;
