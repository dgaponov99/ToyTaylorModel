classdef Polynomial
    
    properties
        coef = [];
        order;
        degree;
        x0 = 0;
    end
    
    methods
        function obj =  Polynomial(a, varargin)
            if (nargin >= 3) && (string(varargin{nargin - 2}) == "x0")
                obj.x0 = varargin{nargin - 1};
                if nargin > 3
                    obj.coef = sparse(a, varargin{1:nargin-3});
                else
                    obj.coef = sparse(a);
                end
            else
                if nargin > 1
                    obj.coef = sparse(a, varargin{:});
                else
                    obj.coef = sparse(a);
                end
            end
            temp = find(obj.coef);
            obj.degree = temp(length(temp));
            temp= size(obj.coef);
            obj.order = temp(2);
        end
        
        function y = val(self, x)
            y = 0;
            for i = 1:self.degree
                y = y + self.coef(1, i)*(x - self.x0)^(i-1);
            end
        end
        
        function result = plus(obj1, obj2)
            if obj1.x0 ~= obj2.x0
                error('invalide x0');
            end
            j = [];
            v = [];
            for i = 1:max(obj1.degree, obj2.degree)
                a = obj1.coef(1, i);
                b = obj2.coef(1, i);
                if (a ~= 0) || (b ~= 0)
                    j = [j, i];
                    v = [v, a + b+0];
                end
            end
            i = ones(size(j));
            result = Polynomial(i, j, v, 1, max(obj1.order, obj2.order), 'x0', obj1.x0);
        end
        
        function result = minus(obj1, obj2)
            if obj1.x0 ~= obj2.x0
                error('invalide x0');
            end
            j = [];
            v = [];
            for i = 1:max(obj1.degree, obj2.degree)
                a = obj1.coef(1, i);
                b = obj2.coef(1, i);
                if (a ~= 0) || (b ~= 0)
                    j = [j, i];
                    v = [v, a - b+0];
                end
            end
            i = ones(size(j));
            result = Polynomial(i, j, v, 1, max(obj1.order, obj2.order), 'x0', obj1.x0);
        end
        
        function result = times(obj1, obj2)
            result = Polynomial(obj1*obj2.coef, 'x0', obj2.x0);
        end
    end
    
end

