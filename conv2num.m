function arr = conv2num(arr)
    for i = 1:length(arr)
        arr{i} = str2num(arr{i});
    end
end

