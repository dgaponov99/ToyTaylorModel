classdef MultiPolynomial
%    ����� �������� ������ ���������� � ���������� �� ��������
    
    properties (Access = private)
        varNumber;
        degree;
        coeffs;
        x0;
    end
    
    methods
        function obj = MultiPolynomial(varNumber, degree, positions, values, x0)
            %   varNumber - ����� ���������� ��������
            %   degree - ������� �������� (����� ����������� ��� �������� �� ����������� ��� �����)
            %   positions - ������ ����� � ������������ ���������� (��������: {[2 0] [1 1] [0 2]})
            %   values - �������� ������������� ��������������� ���������
            %(��������: [1 2 1])
            %   x0 - ����� ���������� �������� (�����������)
            obj.varNumber = varNumber;
            obj.degree = degree;
            obj.coeffs = containers.Map(conv2str(positions), values);
            if nargin > 4
                obj.x0 = x0;
            else
                obj.x0 = zeros(1, varNumber);
            end
        end
        
        function value = value(self, x)
            %   �������� �������� � ����� x
            value = 0;
            strKeys = self.coeffs.keys;
            for i = 1:length(strKeys)
                term = self.coeffs(strKeys{i});
                quantitys = str2num(strKeys{i});
                for j = 1:self.varNumber
                    term = term*(x(j) - self.x0(j))^(quantitys(j));
                end
                value = value + term;
            end
        end
        
        function str = toString(self)
            %   ��������� ������������� ��������
            str = "";
            strKeys = self.coeffs.keys;
            for i = 1:length(strKeys)
                term = num2str(self.coeffs(strKeys{i}));
                quantitys = str2num(strKeys{i});
                for j = 1:self.varNumber
                    q = quantitys(j);
                    if q ~= 0
                        term = strcat(term, "(x", num2str(j));
                        if self.x0(j) < 0
                            term = strcat(term, " + ", num2str(abs(self.x0(j))), ")");
                        else
                            term = strcat(term, " - ", num2str(self.x0(j)), ")");
                        end
                        if q > 1
                            term = strcat(term, "^", num2str(q));
                        end
                    end
                end
                if strlength(str) > 0
                    str = strcat(str, " + ", term);
                else
                    str = term;
                end
            end
        end
        
    end
end

