classdef Polynomial
    
    properties
        coef
        degree
    end
    
    methods
        function obj =  Polynomial(a, b, v, n) 
            switch nargin
                case 1
                    obj.coef = sparse(a);
                case 3
                    obj.coef = sparse(a, b, v);
                case 4
                    obj.coef = sparse(a, b, v, n);
            end
            temp = find(obj.coef);
            obj.degree = temp(length(temp));
        end
    end
    
end

