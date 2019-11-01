classdef MultiPolynomial
%    Класс полинома многих переменных в разложении по степеням
    
    properties (Access = private)
        dimX;
        coeffs;
        x0;
    end
    
    methods
        function obj = MultiPolynomial(positions, values, x0)
            %   dimX - размерность пространства
            %   positions - массив ячеек с показателями слогаемого (например: {[2 0] [1 1] [0 2]})
            %   values - значения коэффициентов соответствующих слогаемых
            %(например: [1 2 1])
            %   x0 - (опционально) точка разложения полинома
            if isa(positions, 'containers.Map')
                obj.dimX = uint32(values);
                obj.coeffs = positions;
            else
                obj.dimX = uint32(length(positions{1}));
                obj.coeffs = containers.Map(conv2str(positions), values);
            end
            if nargin > 2
                obj.x0 = x0;
            else
                obj.x0 = zeros(1, obj.dimX);
            end
        end
        
        function value = value(self, x)
            %   Значение полинома в точке x
            value = 0;
            strKeys = self.coeffs.keys;
            for i = 1:length(strKeys)
                term = self.coeffs(strKeys{i});
                quantitys = str2num(strKeys{i});
                for j = 1:self.dimX
                    term = term*(x(j) - self.x0(j))^(quantitys(j));
                end
                value = value + term;
            end
        end
        
        function str = toString(self)
            %   Строковое представление полинома
            str = "";
            strKeys = self.coeffs.keys;
            for i = 1:length(strKeys)
                quantitys = str2num(strKeys{i});
                term = "";
                if quantitys*ones(self.dimX, 1) > 0
                    if self.coeffs(strKeys{i}) ~= 1
                        term = num2str(self.coeffs(strKeys{i}));
                    end
                    for j = 1:self.dimX
                        q = quantitys(j);
                        if q ~= 0
                            if self.x0(j) ~= 0
                                term = strcat(term, "(x", num2str(j));
                                if self.x0(j) < 0
                                    term = strcat(term, " + ", num2str(abs(self.x0(j))), ")");
                                else
                                    term = strcat(term, " - ", num2str(self.x0(j)), ")");
                                end
                            else
                                term = strcat(term, "x", num2str(j));
                            end
                            if q > 1
                                term = strcat(term, "^", num2str(q));
                            end
                        end
                    end
                else
                    term = strcat(term, num2str(self.coeffs(strKeys{i})));
                end
                
                if strlength(str) > 0
                    str = strcat(str, " + ", term);
                else
                    str = term;
                end
            end
        end
        
        function disp(obj)
            disp(obj.toString());
        end
        
        function value = plus(obj1, obj2)
            if ~isa(obj1, 'MultiPolynomial') || ~isa(obj2, 'MultiPolynomial')
                error("Arguments must be object 'MultiPolynomial'");
            end
            if obj1.getDimX() ~= obj2.getDimX()
                error("Dimensions must be concide");
            end 
            if obj1.getX0() ~= obj2.getX0()
                error("Start points must be concide");
            end
            
            coeffs1 = containers.Map(obj1.getCoeffs().keys, obj1.getCoeffs().values);
            coeffs2 = obj2.getCoeffs();
            keys2 = coeffs2.keys();
            
            for i = 1:length(keys2)
                key = keys2{i};
                if coeffs1.isKey(key)
                    coeffs1(key) = coeffs1(key) + coeffs2(key);
                else
                    coeffs1(key) = coeffs2(key);
                end
            end
            
            value = MultiPolynomial(coeffs1, obj1.getDimX(), obj1.getX0());
        end
        
        function value = minus(obj1, obj2)
            if ~isa(obj1, 'MultiPolynomial') || ~isa(obj2, 'MultiPolynomial')
                error("Arguments must be object 'MultiPolynomial'");
            end
            if obj1.getDimX() ~= obj2.getDimX()
                error("Dimensions must be concide");
            end 
            if obj1.getX0() ~= obj2.getX0()
                error("Start points must be concide");
            end
            
            coeffs1 = containers.Map(obj1.getCoeffs().keys, obj1.getCoeffs().values);
            coeffs2 = obj2.getCoeffs();
            keys2 = coeffs2.keys();
            
            for i = 1:length(keys2)
                key = keys2{i};
                if coeffs1.isKey(key)
                    coef = coeffs1(key) - coeffs2(key);
                    if coef ~= 0
                        coeffs1(key) = coef;
                    else
                        coeffs1.remove(key);
                    end
                else
                    coeffs1(key) = -coeffs2(key);
                end
            end
            
            value = MultiPolynomial(coeffs1, obj1.getDimX(), obj1.getX0());
        end
        
        function dimX = getDimX(self)
            dimX = self.dimX;
        end
        
        function coeffs = getCoeffs(self)
            coeffs = self.coeffs;
        end
        
        function x0 = getX0(self)
            x0 = self.x0;
        end
        
    end
end

