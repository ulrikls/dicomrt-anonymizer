

function out = searchstruct(structname, searchstr, replacestr)

out = structfun(@(x) replaceUID(x, searchstr, replacestr), structname, 'UniformOutput',false);

end

function out = replaceUID(in, searchstr, replacestr)
 
    if ischar(in)
        out = strrep(in, searchstr, replacestr);
    elseif isstruct(in)
        out = structfun(@(x) replaceUID(x, searchstr, replacestr), in, 'UniformOutput',false);
    else
        out = in;
    end
end
