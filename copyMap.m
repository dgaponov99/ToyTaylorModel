function cm = copyMap(map)
    if ~isa(map, 'containers.Map')
        error('Argumetn must be Map object')
    end
    
    keys = map.keys();
    values = zeros(1, length(keys));
    for i = 1:length(keys)
        values(i) = map(keys{i});
    end
    cm = containers.Map(keys, values);
end

