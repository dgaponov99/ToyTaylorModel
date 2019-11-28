classdef MP
    
    methods (Static)
        function c = coef(p, key)
            c = p.values(p.coefs(key));
        end
        
        function s = str(p)
            keys = p.coefs.keys();
            dimX = p.dimX;
            x0 = p.x0;
            s = "";
            for i = 1:length(keys)
                coef = MP.coef(p, keys{i});
                s = strcat(s, " + ", num2str(coef));
                key = str2num(keys{i}); %#ok<ST2NM>
                for j = 1:dimX
                    if key(j) ~= 0
                        s = strcat(s, "(x", num2str(j));
                        if x0(j) ~=0
                            s = strcat(s, " - ", num2str(x0(j)));
                        end
                        s = strcat(s, ")");
                        if key(j) ~= 1
                            s = strcat(s, "^", num2str(key(j)));
                        end
                    end
                end
            end
        end
        
        function disp(p)
            disp(MP.str(p))
        end
        
        function y = value(p, x)
            sz = size(x);
            x = x - p.x0;
            keys = p.coefs.keys();
            y = zeros(1, sz(2));
            for i = 1:length(keys)
                degrees = str2num(keys{i});
                m = x.^(degrees');  
                fact = 1 + zeros(1, sz(2));
                for j = 1:sz(1)
                    fact = fact .* m(j, :);
                end
                MP.coef(p, keys{i});
                y = y + MP.coef(p, keys{i}).*fact;
            end
        end
        
        function p = plus(p1, p2)
            coefs = copyMap(p1.coefs);
            values = p1.values;
            x0 = p1.x0;
            keys = p2.coefs.keys();
            for i = 1:length(keys)
                key = keys{i};
                if coefs.isKey(key)
                    s = MP.coef(p1, key) + MP.coef(p2, key);
                    if s ~= 0
                        values(coefs(key)) = s;
                    else
                        coefs.remove(key);
                    end
                else
                    s = MP.coef(p2, key);
                    if s ~= 0
                        values = [values, s];
                        coefs(key) = length(values);
                    end
                end
            end
            p = MPoly(coefs, values, x0);
        end
        
        function p = minus(p1, p2)
            coefs = copyMap(p1.coefs);
            values = p1.values;
            x0 = p1.x0;
            keys = p2.coefs.keys();
            for i = 1:length(keys)
                key = keys{i};
                if coefs.isKey(key)
                    s = MP.coef(p1, key) - MP.coef(p2, key);
                    if s ~= 0
                        values(coefs(key)) = s;
                    else
                        coefs.remove(key);
                    end
                else
                    s = -MP.coef(p2, key);
                    if s ~= 0
                        values = [values, s];
                        coefs(key) = length(values);
                    end
                end
            end
            p = MPoly(coefs, values, x0);
        end
        
        function p = mtimes(p1, p2)
            coefs = copyMap(p1.coefs);
            values = p1.values;
            x0 = p1.x0;
            p = 0;
        end
        
        function p = updateValues(p)
            keys = p.coefs.keys();
            values = zeros(1, length(keys));
            for i = 1:length(keys)
                values(i) = MP.coef(p, keys{i});
            end
            p.values = values;
            p.coefs = containers.Map(keys, 1:length(keys));
        end
    end
end

