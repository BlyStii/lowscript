local function getErrorLine(file, line, message)
    return "lowscript-error: " .. file .. ":" .. line .. ": " .. message
end

local stack = {}

local new_line = true

local latest_line = 0

local s, e = pcall(function()
    local function copy(obj, seen)
        if type(obj) ~= 'table' then return obj end
        if seen and seen[obj] then return seen[obj] end
        local s = seen or {}
        local res = setmetatable({}, getmetatable(obj))
        s[obj] = res
        for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
        return res
    end

    local list_functions = {
        ["push"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@"
                },
                {
                    type = "IDE",
                    value = "pos@"
                }
            }
        },
        ["pop"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "pos@"
                }
            }
        },
        ["clear"] = {
            parameters = {}
        },
        ["join"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "sep@",
                    datatypes = {
                        {
                            type = "IDE",
                            value = "string"
                        }
                    }
                }
            }
        },
        ["has"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@"
                }
            }
        },
        ["reverse"] = {
            parameters = {}
        }
    }

    local string_functions = {
        ["has"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@",
                    datatypes = {
                        {
                            type = "IDE",
                            value = "string"
                        }
                    }
                }
            }
        },
        ["split"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@",
                    datatypes = {
                        {
                            type = "IDE",
                            value = "string"
                        }
                    }
                }
            }
        },
        ["upper"] = {
            parameters = {}
        },
        ["lower"] = {
            parameters = {}
        },
        ["reverse"] = {
            parameters = {}
        }
    }

    function createTraceback(f)
        table.insert(stack, {
                file = f,
                trace = "in main chunk",
                line = "?"
        })
    end

    function addTrace(t, l)
        l = l or "?"

        table.insert(stack, {
            file = stack[1].file,
            trace = t,
            line = l
        })
    end

    function removeTrace()
        table.remove(stack)
    end

    local function giveError(value, line)
        line = line or "?"
        print(getErrorLine(stack[#stack].file, line, value))
        print(getTraceback(stack, line))

        new_line = true
        error()
    end

    local function exit()
        error("exit")
    end

    local function getToken(value)
        if value == nil then
            return "null"
        end

        if value.type == "ADD" then
            return "+"
        elseif value.type == "SUB" then
            return "-"
        elseif value.type == "MLT" then
            return "*"
        elseif value.type == "DIV" then
            return "/"
        elseif value.type == "BAR" then
            return "|"
        elseif value.type == "AND" then
            return "&"
        elseif value.type == "XOR" then
            return "^"
        elseif value.type == "PRC" then
            return "%"
        elseif value.type == "EXC" then
            return "!"
        elseif value.type == "QST" then
            return "?"
        elseif value.type == "LPA" then
            return "("
        elseif value.type == "RPA" then
            return ")"
        elseif value.type == "LBA" then
            return "["
        elseif value.type == "RBA" then
            return "]"
        elseif value.type == "INF" then
            return "<"
        elseif value.type == "SUP" then
            return ">"
        elseif value.type == "HSH" then
            return "#"
        elseif value.type == "LBR" then
            return "{"
        elseif value.type == "RBR" then
            return "}"
        elseif value.type == "ATS" then
            return "@"
        elseif value.type == "DOT" then
            return "."
        elseif value.type == "COM" then
            return ","
        elseif value.type == "COL" then
            return ":"
        elseif value.type == "SCL" then
            return ";"
        elseif value.type == "UND" then
            return "_"
        elseif value.type == "EQL" then
            return "="
        elseif value.type == "NUM" then
            return "number"
        elseif value.type == "STR" then
            return "string"
        elseif value.type == "BOL" then
            return "bool"
        elseif value.type == "NUL" or value == nil then
            return "null"
        elseif value.type == "IDE" then
            return "identifier"
        elseif value.type == "SET" then
            return "set"
        end
    end

    local function getValue(value)
        if value == nil then
            return "null"
        end

        if value.type == "IDE" and not value.value then
            return "''"
        end

        if value.type == "ADD" then
            return "+"
        elseif value.type == "SUB" then
            return "-"
        elseif value.type == "MLT" then
            return "*"
        elseif value.type == "DIV" then
            return "/"
        elseif value.type == "BAR" then
            return "|"
        elseif value.type == "AND" then
            return "&"
        elseif value.type == "XOR" then
            return "^"
        elseif value.type == "PRC" then
            return "%"
        elseif value.type == "EXC" then
            return "!"
        elseif value.type == "QST" then
            return "?"
        elseif value.type == "LPA" then
            return "("
        elseif value.type == "RPA" then
            return ")"
        elseif value.type == "LBA" then
            return "["
        elseif value.type == "RBA" then
            return "]"
        elseif value.type == "INF" then
            return "<"
        elseif value.type == "SUP" then
            return ">"
        elseif value.type == "HSH" then
            return "#"
        elseif value.type == "LBR" then
            return "{"
        elseif value.type == "RBR" then
            return "}"
        elseif value.type == "ATS" then
            return "@"
        elseif value.type == "DOT" then
            return "."
        elseif value.type == "COM" then
            return ","
        elseif value.type == "COL" then
            return ":"
        elseif value.type == "SCL" then
            return ";"
        elseif value.type == "UND" then
            return "_"
        elseif value.type == "EQL" then
            return "="
        elseif value.type == "NUM" then
            return value.value
        elseif value.type == "STR" then
            return value.value
        elseif value.type == "BOL" then
            return value.value
        elseif value.type == "NUL" or value == nil then
            return "null"
        elseif value.type == "IDE" then
            return value.value
        elseif value.type == "SET" then
            return value.elements
        elseif value.type == "FIL" then
            return value.file
        end
    end

    -- INFO: VARIABLES
    local scopes = {
        ["math.pi"] = {
            type = "NUM",
            value = math.pi
        },
        ["math.euler"] = {
            type = "NUM",
            value = math.exp(1)
        }
    }
    local in_scopes = {}

    local data_types = {
        "number",
        "string",
        "bool",
        "set",
        "null",
        "function",
        "file"
    }

    -- INFO: CLASSES
    local classes = {}

    -- INFO: FUNCTIONS
    local functions = {
        ["line"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@"
                }
            }
        },
        ["write"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@"
                }
            }
        },
        ["error"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@"
                }
            }
        },
        ["input"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@"
                }
            }
        },
        ["type"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@"
                }
            }
        },
        ["math"] = {
            ["random"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "min@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "max@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["clamp"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "min@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "max@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["min"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "min@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["max"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "max@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["pow"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "y@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["abs"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["floor"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["ceil"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["round"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "dec@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            },
                            {
                                type = "IDE",
                                value = "null"
                            }
                        }
                    }
                }
            },
            ["sqrt"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["sin"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["cos"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["tan"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["ln"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["log"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "y@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["rad"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
            ["deg"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "x@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "number"
                            }
                        }
                    }
                }
            },
        },
        ["num"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@"
                }
            }
        },
        ["str"] = {
            parameters = {
                {
                    type = "IDE",
                    value = "v@"
                }
            }
        },
        ["files"] = {
            ["open"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "file@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "string"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "mode@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "string"
                            },
                            {
                                type = "IDE",
                                value = "null"
                            }
                        }
                    }
                }
            },
            ["read"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "file@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "file"
                            }
                        }
                    }
                }
            },
            ["write"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "file@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "file"
                            }
                        }
                    },
                    {
                        type = "IDE",
                        value = "v@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "string"
                            }
                        }
                    }
                }
            }
        },
        ["sys"] = {
            ["exit"] = {
                parameters = {}
            },
            ["traceback"] = {
                parameters = {
                    {
                        type = "IDE",
                        value = "msg@",
                        datatypes = {
                            {
                                type = "IDE",
                                value = "string"
                            },
                            {
                                type = "IDE",
                                value = "null"
                            }
                        }
                    }
                }
            }
        }
    }

    function new_scope()
        table.insert(in_scopes, {})
    end

    function add_var(key, value, isglobal, datatypes)
        if not scopes[key] then
            if isglobal then
                table.insert(in_scopes[1], key)
            else
                table.insert(in_scopes[#in_scopes], key)
            end
        end

        scopes[key] = copy(value)

        scopes[key].datatypes = copy(datatypes)
    end

    function add_func(key, value, isglobal, has_path)
        has_path = has_path or functions

        if isglobal then
            table.insert(in_scopes[1], key)
        else
            table.insert(in_scopes[#in_scopes], key)
        end
        has_path[key] = copy(value)
    end

    function add_class(key, value, isglobal, has_path)
        has_path = has_path or classes

        if isglobal then
            table.insert(in_scopes[1], key)
        else
            table.insert(in_scopes[#in_scopes], key)
        end
        has_path[key] = copy(value)
    end

    function remove_scope()
        for i, v in pairs(in_scopes[#in_scopes]) do
            scopes[v] = nil
            functions[v] = nil
            classes[v] = nil
        end
        table.remove(in_scopes, #in_scopes)
    end

    new_scope()

    local sysargs = {
        type = "SET",
        elements = {}
    }

    for i, v in pairs(arg) do
        sysargs.elements[{
            type = "NUM",
            value = tostring(i)
        }] = {
            type  = "STR",
            value = v
        }
    end

    add_var("sys.args", sysargs, true)

    function equal_lists(list1, list2)
        if type(list1) ~= "table" or type(list2) ~= "table" then
            return false
        end

        if get_length(list1) ~= get_length(list2) then
            return false
        end

        for i, v in pairs(list1) do
            if type(i) == "table" and type(find_value(list2, v)) == "table" then
                if not equal_lists(i, find_value(list2, v)) then
                    return false
                end
            elseif type(v) == "table" and type(find_index(list2, i)) == "table" then
                if not equal_lists(v, find_index(list2, i)) then
                    return false
                end
            elseif list1[i] ~= list2[i] then
                return false
            end
        end
        return true
    end

    function get_length(list)
        local length = 0
        for i, v in pairs(list) do
            if type(i) ~= "table" then
                goto continue
            end

            if tonumber(i.value) and tonumber(i.value) >= length then
                length = tonumber(i.value) + 1
            end

            ::continue::
        end

        return length
    end

    function find_ival(list, _value)
        for i, v in pairs(list) do
            if i.value == _value then
                return true
            end
        end

        return false
    end

    function biggest_digit(list)
        local digit = 0
        for i, v in pairs(list) do
            if not find_ival(list, tostring(digit)) then
                return digit
            end

            if i.type and i.type == "NUM" then
                if tonumber(i.value) > digit then
                    digit = tonumber(i.value)
                end
            end
        end

        return digit + 1
    end

    function math.round(value, decimals)
        decimals = decimals or 0

        value = (value * (10 ^ decimals))
        if value then
            if value - math.floor(value) < math.ceil(value) - value then
                return math.floor(value) / (10 ^ decimals)
            else
                return math.ceil(value) / (10 ^ decimals)
            end
        end
    end

    function math.clamp(value, minimum, maximum)
        if value < minimum then
            return minimum
        end
        if value > maximum then
            return maximum
        end
        return value
    end

    function find_value(array, value)
        for i, v in pairs(array) do
            if type(v) == "table" then
                if equal_lists(v, value) then
                    return i
                end
            else
                if v == value then
                    return i
                end
            end
        end

        return nil
    end

    function get_appar(str, value)
        local appar = 0

        for i = 1, #str do
            if string.sub(str, i, i) == value and string.sub(str, i - 1, i - 1) ~= "\\" then
                appar = appar + 1
            end
        end

        return appar
    end

    function find_index(array, index)
        for i, v in pairs(array) do
            if type(i) == "table" then
                if equal_lists(i, index) then
                    return v
                end
            else
                if i == index then
                    return v
                end
            end
        end

        return nil
    end

    function to_int(value)
        if not value then
            return
        end

        if not string.find(value, "%.") then
            return tostring(value)
        end

        value = string.reverse(tostring(value))

        local new_value = ""

        local streak = 1
        for i = 1, #value do
            local char = string.sub(value, i, i)

            if char ~= "0" then
                if char == "." then
                    streak = i + 1
                else
                    streak = i
                end
                break
            end
        end

        for i = streak, #value do
            new_value = new_value .. string.sub(value, i, i)
        end

        return string.reverse(new_value)
    end

    function var(interp, _ide, isglobal, datatypes)
        if isglobal then
            if scopes[_ide.value] then
                giveError("attempt to redeclare global '" .. getValue(_ide) .. "'", _ide.line)
            end
        end

        if not interp then
            return
        end

        add_var(_ide.value, interp, isglobal, datatypes)

        if interp.type == "STR" then
            add_var(_ide.value .. ".length", {
                type = "NUM",
                value = tostring(#interp.value)
            }, isglobal, datatypes)

            functions[_ide.value] = {}
            for i, v in pairs(string_functions) do
                add_func(i, v, isglobal, functions[_ide.value])
            end
        elseif interp.type == "SET" then
            add_var(_ide.value .. ".length", {
                type = "NUM",
                value = tostring(get_length(interp.elements))
            }, isglobal, datatypes)

            add_func(_ide.value, copy(list_functions), isglobal, datatypes)
        elseif interp.type == "INS" then
            for i, v in pairs(interp.attributes) do
                var(v, {
                    type = "IDE",
                    value = _ide.value .. "." .. interp.value.attributes[i].value
                }, isglobal)
            end

            local _methods = {}

            for i, v in pairs(interp.value.body) do
                if v.type == "FNC" then
                    table.insert(_methods, copy(v))
                end
            end

            if #_methods > 0 then
                functions[_ide.value] = functions[_ide.value] or {}

                for i, v in pairs(_methods) do
                    add_func(v.identifier.value, {
                        body = v.body,
                        parameters = v.parameters,
                        datatypes = v.datatypes
                    }, isglobal, functions[_ide.value])
                end
            end
        end

        add_var(_ide.value .. ".isnum", {
            type = "BOL",
            value = interp.type == "NUM"
        }, isglobal, datatypes)
    end

    function highconcat(t, sep)
        function c(val)
            if type(val) ~= "table" then
                return val
            end

            local in_str = ""
            for i, v in pairs(val) do
                in_str = in_str .. c(v)
            end

            return in_str
        end

        local str = ""
        for i, v in pairs(t) do
            if str ~= "" then
                str = str .. sep
            end
            str = str .. c(v.value)
        end
        return str
    end

    function find_inval(array, _value, start)
        start = start or 1

        local n_array = {}

        for i = start, #array do
            n_array[i] = array[i]
        end

        for i, v in pairs(n_array) do
            if v.value == _value then
                return i
            end
        end
    end

    function getType(value)
        if value.type == "NUM" then
            return "number"
        elseif value.type == "STR" then
            return "string"
        elseif value.type == "BOL" then
            return "bool"
        elseif value.type == "NUL" or value == nil then
            return "null"
        elseif value.type == "SET" then
            return "set"
        elseif value.func then
            return "function"
        elseif value.type == "FIL" then
            return "file"
        elseif value.type == "INS" then
            return value.value.identifier.value
        elseif value.type == "CLS" then
            return value.identifier.value
        end

        return getToken(value)
    end

    local function clamp(v, min, max)
        if v < min then
            return min
        end
        if v > max then
            return max
        end

        return v
    end

    function get_least(func)
        local params = func.parameters or func.attributes

        local n_params = {}
        for i, v in pairs(params) do
            n_params[i] = params[#params - (i - 1)]
        end

        for i, v in pairs(n_params) do
            if v.datatypes then
                if not find_inval(v.datatypes, "null") then
                    return #params - (i - 1)
                end
            end
        end

        return #params - 1
    end

    function multiplyChar(char, length)
        local result = ""

        for i = 1, length do
            result = result .. char
        end

        return result
    end

    function table.reverse(t)
        local nt = {}

        for i, v in pairs(t) do
            table.insert(nt, t[#t - (i - 1)])
        end

        return nt
    end

    function table.clear(t)
        for i = 1, #t do
            table.remove(t, 1)
        end

        return t
    end

    function getTraceback(s, l)
        local _s = copy(s)

        local result = "stack traceback:"

        _s = table.reverse(_s)

        table.insert(_s, 1, table.remove(_s))

        _s[1].line = l

        local traces = {}

        for i, v in pairs(_s) do
            table.insert(traces, v.trace)
        end

        table.insert(traces, table.remove(traces, 1))

        for i, v in pairs(traces) do
            _s[i].trace = v
        end

        table.insert(_s, {
            file = "[LUA]",
            trace = "in ?",
            line = ""
        })

        for i, v in pairs(_s) do
            _s[i] = {
                location = v.file .. ":" .. v.line .. ":",
                trace = v.trace
            }
        end

        local longest = 0

        for i, v in pairs(_s) do
            if #v.location >= longest then
                longest = #v.location + 1
            end
        end


        for i, v in pairs(_s) do
            result = result .. "\n        " .. v.location .. multiplyChar(" ", longest - #v.location) .. v.trace
        end

        return result
    end

    function new_instance(value, interp, _ide, isglobal)
        addTrace("in class '" .. getValue(interp.identifier) .. "'", interp.identifier.line)

        if #interp.attributes == 0 and #value.parameters ~= 0 then
            giveError("class '" .. getValue(interp.identifier) .. "' requires at least 0 parameters (max 0), got " .. #value.parameters, value.line)
        else
            if #interp.attributes > 0 and interp.attributes[#interp.attributes].type == "CPM" then
                if #value.parameters > ((#interp.attributes - 1) + interp.attributes[#interp.attributes].max) then
                    giveError("class '" .. getValue(interp.identifier) .. "' requires at least " .. #interp.attributes - 1 .. " attributes (max " .. ((#interp.attributes - 1) + interp.attributes[#interp.attributes].max) .. "), got " .. #value.parameters, value.line)
                end
            elseif #value.parameters ~= #interp.attributes then
                if #value.parameters > #interp.attributes then
                    giveError("class '" .. getValue(interp.identifier) .. "' requires at least " .. get_least(interp) .. " attributes (max " .. #interp.attributes .. "), got " .. #value.parameters, value.line)
                end
                for i = #value.parameters + 1, #interp.attributes do
                    if interp.attributes[i].datatypes then
                        if not find_inval(interp.attributes[i].datatypes, "null") then
                            giveError("class '" .. getValue(interp.identifier) .. "' requires at least " ..  get_least(interp) .. " attributes (max " .. #interp.attributes .. "), got " .. #value.parameters, value.line)
                        end
                    end
                end
            end
        end

        for i, v in pairs(interp.attributes) do
            if v.datatypes then
                for j, k in pairs(v.datatypes) do
                    if not find_value(data_types, k.value) then
                        giveError("unknown data type '" .. getValue(k) .. "'", k.line)
                    end
                end
            end
        end

        local attribs = {}
        for i, v in pairs(value.parameters) do
            local _interp = interpret(v)
            if interp.attributes[i] and interp.attributes[i].datatypes then
                if not find_inval(interp.attributes[i].datatypes, getType(_interp)) then
                    giveError("attribute " .. i .. " in class '" .. getValue(interp.identifier) .. "': expected " .. highconcat(interp.attributes[i].datatypes, " or ") .. ", got " .. getType(_interp), interp.attributes[i].line)
                end
            end
            table.insert(attribs, _interp)
        end

        --[[
        for i, v in pairs(interp.attributes) do
            if v.type == "CPM" then
                local list = {
                    type = "SET",
                    elements = {}
                }
                for j = i, #attribs do
                    list.elements[{
                        type = "NUM",
                        value = tostring(get_length(list.elements))
                    }] = attribs[j]
                end

                var(list, v)

                break
            else
                if attribs[i] then
                    var(attribs[i], v)
                else
                    var({
                        type = "NUL",
                        value = "null"
                    }, v)
                end
            end
        end
        ]]

        local _methods = {}
        for i, v in pairs(interp.body) do
            if v.type == "FNC" then
                _methods[v.identifier.value] = {
                    parameters = v.parameters,
                    body = v.body,
                    datatypes = v.datatypes
                }
            end
        end

        if not functions[_ide.value] then
            add_func(_ide.value, {}, isglobal)
        end

        for i, v in pairs(_methods) do
            add_func(i, v, isglobal, functions[_ide.value])
        end

        removeTrace()

        return {
            type = "INS",
            value = interp,
            attributes = attribs
        }
    end

    local function searchFor(t, s)
        for i, v in pairs(t) do
            if type(v) == "table" then
                if searchFor(v, s) then
                    return searchFor(v, s)
                end
            else
                if i == s then
                    return v
                end
            end
        end
    end

    function interpreter(ast)
        -- INFO: INTERPRETER

        function interpret(node, _path, ide_path, class_path, ins_path)
            latest_line = searchFor(node, "line")

            local v_path
            if _path then
                v_path = {}

                for i, v in pairs(_path) do
                    if v.type == "IDE" then
                       v_path[i] = v
                    else
                        v_path[i] = v.value
                    end
                end
            end

            if (not node) or node.type == "NUL" then
                return {
                    type = "NUL",
                    value = "null"
                }
            elseif node.type == "NUM" or node.type == "STR" or node.type == "BOL" then
                return node
            end

            if node.type == "ADD" then
                -- INFO: ADDITION

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "NUM" or right.type ~= "NUM" then
                    if left.type ~= "NUM" then
                        giveError("attempt to add " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to add " .. getType(left) .. " with " .. getType(right), right.line)
                end

                return {
                    type = "NUM",
                    value = tostring(tonumber(left.value) + tonumber(right.value))
                }
            elseif node.type == "SUB" then
                -- INFO: SUBTRACTION

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "NUM" or right.type ~= "NUM" then
                    if left.type ~= "NUM" then
                        giveError("attempt to subtract " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to subtract " .. getType(left) .. " with " .. getType(right), right.line)
                end

                return {
                    type = "NUM",
                    value = tostring(tonumber(left.value) - tonumber(right.value))
                }
            elseif node.type == "MLT" then
                -- INFO: MULTIPLICATION

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "NUM" or right.type ~= "NUM" then
                    if left.type ~= "NUM" then
                        giveError("attempt to multiply " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to multiply " .. getType(left) .. " with " .. getType(right), right.line)
                end

                return {
                    type = "NUM",
                    value = tostring(tonumber(left.value) * tonumber(right.value))
                }
            elseif node.type == "DIV" then
                -- INFO: DIVISION

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "NUM" or right.type ~= "NUM" then
                    if left.type ~= "NUM" then
                        giveError("attempt to divide " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to divide " .. getType(left) .. " with " .. getType(right), right.line)
                end

                return {
                    type = "NUM",
                    value = tostring(tonumber(left.value) / tonumber(right.value))
                }
            elseif node.type == "PRC" then
                -- INFO: MODULO

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "NUM" or right.type ~= "NUM" then
                    if left.type ~= "NUM" then
                        giveError("attempt to modulo " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to modulo " .. getType(left) .. " with " .. getType(right), right.line)
                end

                return {
                    type = "NUM",
                    value = tostring(tonumber(left.value) % tonumber(right.value))
                }
            end

            if node.type == "BAR" then
                -- INFO: OR GATE

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "BOL" or right.type ~= "BOL" then
                    if left.type ~= "BOL" then
                        giveError("attempt to logical or " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to logical or " .. getType(left) .. " with " .. getType(right), right.line)
                end

                if left.value == "true" or right.value == "true" then
                    return {
                        type = "BOL",
                        value = "true"
                    }
                end
                return {
                    type = "BOL",
                    value = "false"
                }
            elseif node.type == "AND" then
                -- INFO: AND GATE

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "BOL" or right.type ~= "BOL" then
                    if left.type ~= "BOL" then
                        giveError("attempt to logical and " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to logical and " .. getType(left) .. " with " .. getType(right), right.line)
                end

                if left.value == "true" and right.value == "true" then
                    return {
                        type = "BOL",
                        value = "true"
                    }
                end
                return {
                    type = "BOL",
                    value = "false"
                }
            elseif node.type == "XOR" then
                -- INFO: XOR GATE

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "BOL" or right.type ~= "BOL" then
                    if left.type ~= "BOL" then
                        giveError("attempt to logical xor " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to logical xor " .. getType(left) .. " with " .. getType(right), right.line)
                end

                if not ((left.value == "true" and right.value == "true") or (left.value == "false" and right.value == "false")) then
                    return {
                        type = "BOL",
                        value = "true"
                    }
                end
                return {
                    type = "BOL",
                    value = "false"
                }
            elseif node.type == "EXC" then
                -- INFO: NOT GATE

                local val = interpret(node.value)

                if val.type ~= "BOL" then
                    giveError("attempt to logical not " .. getType(val), val.line)
                end

                if val.value == "false" then
                    return {
                        type = "BOL",
                        value = "true"
                    }
                end
                return {
                    type = "BOL",
                    value = "false"
                }
            end

            if node.type == "EQL" then
                -- INFO: EQUAL

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type == "SET" and right.type == "SET" then
                    if equal_lists(left.elements, right.elements) then
                        return {
                            type = "BOL",
                            value = "true"
                        }
                    else
                        return {
                            type = "BOL",
                            value = "false"
                        }
                    end
                elseif left.type ~= "SET" and right.type ~= "SET" and left.type == right.type and left.value == right.value then
                    return {
                        type = "BOL",
                        value = "true"
                    }
                end

                return {
                    type = "BOL",
                    value = "false"
                }
            elseif node.type == "NQL" then
                -- INFO: NOT EQUAL

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type == "SET" and right.type == "SET" then
                    if not equal_lists(left.elements, right.elements) then
                        return {
                            type = "BOL",
                            value = "true"
                        }
                    else
                        return {
                            type = "BOL",
                            value = "false"
                        }
                    end
                elseif left.type ~= "SET" and right.type ~= "SET" and left.type ~= right.type or left.value ~= right.value then
                    return {
                        type = "BOL",
                        value = "true"
                    }
                end
                return {
                    type = "BOL",
                    value = "false"
                }
            elseif node.type == "INF" then
                -- INFO: INFERIOR

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "NUM" or right.type ~= "NUM" then
                    if left.type ~= "NUM" then
                        giveError("attempt to compare (inferior) " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to compare (inferior) " .. getType(left) .. " with " .. getType(right), right.line)
                end

                return {
                    type = "BOL",
                    value = tostring(tonumber(left.value) < tonumber(right.value))
                }
            elseif node.type == "IQL" then
                -- INFO: INFERIOR EQUAL

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "NUM" or right.type ~= "NUM" then
                    if left.type ~= "NUM" then
                        giveError("attempt to compare (inferior-equal) " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to compare (inferior-equal) " .. getType(left) .. " with " .. getType(right), right.line)
                end

                return {
                    type = "BOL",
                    value = tostring(tonumber(left.value) <= tonumber(right.value))
                }
            elseif node.type == "SUP" then
                -- INFO: SUPERIOR

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "NUM" or right.type ~= "NUM" then
                    if left.type ~= "NUM" then
                        giveError("attempt to compare (superior) " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to compare (superior) " .. getType(left) .. " with " .. getType(right), right.line)
                end

                return {
                    type = "BOL",
                    value = tostring(tonumber(left.value) > tonumber(right.value))
                }
            elseif node.type == "SQL" then
                -- INFO: SUPERIOR EQUAL

                local left = interpret(node.left)
                local right = interpret(node.right)

                if left.type ~= "NUM" or right.type ~= "NUM" then
                    if left.type ~= "NUM" then
                        giveError("attempt to compare (superior-equal) " .. getType(left) .. " with " .. getType(right), left.line)
                    end

                    giveError("attempt to compare (superior-equal) " .. getType(left) .. " with " .. getType(right), right.line)
                end

                return {
                    type = "BOL",
                    value = tostring(tonumber(left.value) >= tonumber(right.value))
                }
            end

            if node.type == "DOL" then
                -- INFO: STRING FORMATTING

                local str = interpret(node.value)

                if str.type ~= "STR" then
                    giveError("attempt to format " .. getType(str), str.line)
                end

                if get_appar(str.value, "{") ~= get_appar(str.value, "}") or get_appar(str.value, "{") == 0 then
                    return str
                end

                local new_str = ""
                local chunk = ""

                for i = 1, #str.value do
                    local char = string.sub(str.value, i, i)

                    if char == "{" and string.sub(str.value, i - 1, i - 1) ~= "\\" then
                        new_str = new_str .. chunk
                        chunk = ""
                    elseif char == "}" and string.sub(str.value, i - 1, i - 1) ~= "\\" then
                        local interp = parse(lexer(split(chunk, node.value.line)), {}, true)
                        if #interp > 1 then
                            giveError("attempt to format a non-expression", str.line)
                        end
                        interp = interpret(interp[1])

                        if interp.type ~= "STR" then
                            giveError("attempt to format " .. getType(interp), str.line)
                        end

                        new_str = new_str .. interp.value

                        chunk = ""
                    elseif not (char == "\\" and string.sub(str.value, i - 1, i - 1) ~= "\\") then
                        chunk = chunk .. char
                    end
                end

                return {
                    type = "STR",
                    value = new_str .. chunk
                }
            end

            if node.type == "IFS" then
                -- INFO: IF STATEMENT

                new_scope()

                local condition = interpret(node.condition)
                if condition.type == "BOL" and condition.value == "true" then
                    for i, v in pairs(node.body) do
                        local interp = interpret(v)
                        if interp and interp.type == "RET" then
                            remove_scope()
                            return interp
                        elseif interp and interp.type == "BRK" then
                            remove_scope()
                            return interp
                        elseif interp and interp.type == "CON" then
                            remove_scope()
                            return interp
                        end
                    end
                elseif node.else_body then
                    for i, v in pairs(node.else_body) do
                        local interp = interpret(v)
                        if interp and interp.type == "RET" then
                            remove_scope()
                            return interp
                        elseif interp and interp.type == "BRK" then
                            remove_scope()
                            return interp
                        elseif interp and interp.type == "CON" then
                            remove_scope()
                            return interp
                        end
                    end
                end

                remove_scope()

                return
            elseif node.type == "FOR" then
                -- INFO: FOR LOOP

                new_scope()

                local p1 = node.parameters[1]
                local p2 = node.parameters[2]
                local p3 = node.parameters[3]

                interpret(p1)

                local i_p2 = interpret(p2)
                while i_p2.type == "BOL" and i_p2.value == "true" do
                    for i, v in pairs(node.body) do
                        local interp = interpret(v)
                        if interp and interp.type == "RET" then
                            remove_scope()
                            return interp
                        elseif interp and interp.type == "BRK" then
                            remove_scope()
                            return
                        elseif interp and interp.type == "CON" then
                            break
                        end
                    end

                    interpret(p3)
                    i_p2 = interpret(p2)
                end

                remove_scope()

                return
            elseif node.type == "FRC" then
                -- INFO: FOREACH LOOP

                new_scope()

                local key = node.parameters[1]
                local value = node.parameters[2]

                local list = interpret(node.list)

                if key.type ~= "IDE" then
                    giveError("expected identifier for key in foreach loop", key.line)
                end
                if value and value.type ~= "IDE" then
                    giveError("expected identifier for value in foreach loop", value.line)
                end

                if not list.elements then
                    giveError("attempt to loop through " .. getType(list), value.line)
                end

                local ord_key = {}
                local ord_value = {}

                for i, v in pairs(list.elements) do
                    table.insert(ord_key, i)
                end
                table.sort(ord_key, function(x, y)
                    if (not tonumber(x.value)) or (not tonumber(y.value)) then
                        return x.value < y.value
                    end
                    return tonumber(x.value) < tonumber(y.value)
                end)

                for i, v in pairs(ord_key) do
                    table.insert(ord_value, list.elements[v])
                end

                for j, k in pairs(ord_key) do
                    var(k, key)
                    if value then
                        var(ord_value[j], value)
                    else
                        var(ord_value[j], key)
                    end

                    for i, v in pairs(node.body) do
                        local interp = interpret(v)

                        if interp and interp.type == "RET" then
                            remove_scope()
                            return interp
                        elseif interp and interp.type == "BRK" then
                            remove_scope()
                            return
                        elseif interp and interp.type == "CON" then
                            break
                        end
                    end
                end

                remove_scope()

                return
            elseif node.type == "WHL" then
                -- INFO: WHILE LOOP

                new_scope()

                local condition = interpret(node.condition)
                while true do
                    if not (condition.type == "BOL" and condition.value == "true") then
                        break
                    end

                    for i, v in pairs(node.body) do
                        local interp = interpret(v)
                        if interp and interp.type == "RET" then
                            remove_scope()
                            return interp
                        elseif interp and interp.type == "BRK" then
                            remove_scope()
                            return
                        elseif interp and interp.type == "CON" then
                            break
                        end
                    end

                    condition = interpret(node.condition)
                end

                remove_scope()

                return
            elseif node.type == "RPT" then
                -- INFO: REPEAT LOOP

                new_scope()

                local amount = interpret(node.amount)
                if amount.type ~= "NUM" then
                    giveError("expected number for repeat loop amount, got " .. getType(amount), amount.line)
                end
                if tonumber(amount.value) ~= math.round(tonumber(amount.value)) then
                    giveError("expected integer for repeat loop amount, got " .. getType(amount), amount.line)
                end

                for j = 0, tonumber(amount.value) - 1 do
                    for i, v in pairs(node.body) do
                        local interp = interpret(v)
                        if interp and interp.type == "RET" then
                            remove_scope()
                            return interp
                        elseif interp and interp.type == "BRK" then
                            remove_scope()
                            return
                        elseif interp and interp.type == "CON" then
                            break
                        end
                    end
                end

                remove_scope()

                return
            end


            if node.type == "ASN" then
                -- INFO: VARIABLE ASSIGNMENT

                if functions[node.identifier.value] and not scopes[node.identifier.value] then
                    giveError("attempt to redefine function '" .. getValue(node.identifier) .. "'", node.identifier.line)
                end
                local _ide = node.identifier

                if _ide.type ~= "IDE" then
                    giveError("attempt to assign a value to a " .. getType(_ide) .. " value", _ide.line)
                end

                local value = interpret(node.value)

                if scopes[_ide.value] and scopes[_ide.value].datatypes and node.datatypes then
                    giveError("attempt to redefine type '" .. highconcat(scopes[_ide.value].datatypes, " or ") .. "' to '" .. highconcat(node.datatypes, " or ") .. "' of variable '" .. getValue(_ide) .. "'", _ide.line)
                end

                local _datatypes
                if node.datatypes or (scopes[_ide.value] and scopes[_ide.value].datatypes) then
                    _datatypes = node.datatypes or scopes[_ide.value].datatypes

                    for i, v in pairs(_datatypes) do
                        if not find_value(data_types, v.value) then
                            giveError("unknown data type '" .. getValue(v) .. "'", v.line)
                        end
                    end

                    if not find_inval(_datatypes, getType(value)) then
                        giveError("variable '" .. getValue(_ide) .. "': expected " .. highconcat(_datatypes, " or ") .. ", got " .. getType(value), _ide.line)
                    end
                end

                if value.type == "CLS" then
                    value = new_instance(node.value, value, _ide, false)
                end

                var(value, _ide, false, _datatypes)

                return value
            elseif node.type == "GSN" then
                -- INFO: GLOBAL VARIABLE DECLARATION

                if functions[node.identifier.value] and not scopes[node.identifier.value] then
                    giveError("attempt to redefine function '" .. getValue(node.identifier) .. "'", node.identifier.line)
                end
                local _ide = node.identifier

                if _ide.type ~= "IDE" then
                    giveError("attempt to assign a value to a " .. getType(_ide) .. " value", _ide.line)
                end

                local value = interpret(node.value)

                if scopes[_ide.value] and scopes[_ide.value].datatypes and node.datatypes then
                    giveError("attempt to redefine type '" .. highconcat(scopes[_ide.value].datatypes, " or ") .. "' to '" .. highconcat(node.datatypes, " or ") .. "' of variable '" .. getValue(_ide) .. "'", _ide.line)
                end

                local _datatypes
                if node.datatypes or (scopes[_ide.value] and scopes[_ide.value].datatypes) then
                    _datatypes = node.datatypes or scopes[_ide.value].datatypes

                    for i, v in pairs(_datatypes) do
                        if not find_value(data_types, v.value) then
                            giveError("unknown data type '" .. getValue(v) .. "'", v.line)
                        end
                    end

                    if not find_inval(_datatypes, getType(value)) then
                        giveError("variable '" .. getValue(_ide) .. "': expected " .. highconcat(_datatypes, " or ") .. ", got " .. getType(value), _ide.line)
                    end
                end

                if value.type == "CLS" then
                    value = new_instance(node.value, value, _ide, true)
                end

                var(value, _ide, true, _datatypes)

                return value
            elseif node.type == "FNC" then
                -- INFO: FUNCTION DECLARATION

                if functions[node.identifier.value] and not scopes[node.identifier.value] then
                    giveError("attempt to redefine function '" .. getValue(node.identifier) .. "'", node.identifier.line)
                end

                add_func(node.identifier.value, {
                    body = node.body,
                    parameters = node.parameters,
                    datatypes = node.datatypes
                }, false, class_path)

                return node
            elseif node.type == "GFN" then
                -- INFO: GLOBAL FUNCTION DECLARATION

                if functions[node.identifier.value] and not scopes[node.identifier.value] then
                    giveError("attempt to redefine function '" .. getValue(node.identifier) .. "'", node.identifier.line)
                end
                add_func(node.identifier.value, {
                    body = node.body,
                    parameters = node.parameters,
                    datatypes = node.datatypes
                }, true, class_path)

                return node
            elseif node.type == "CLS" then
                -- INFO: CLASS DECLARATION

                if classes[node.identifier.value] and not scopes[node.identifier.value] then
                    giveError("attempt to redefine class '" .. getValue(node.identifier) .. "'", node.identifier.line)
                end

                add_class(node.identifier.value, {
                    body = node.body,
                    attributes = node.attributes
                }, false, class_path)

                table.insert(data_types, node.identifier.value)

                return node
            elseif node.type == "GCL" then
                -- INFO: GLOBAL CLASS DECLARATION

                if classes[node.identifier.value] and not scopes[node.identifier.value] then
                    giveError("attempt to redefine class '" .. getValue(node.identifier) .. "'", node.identifier.line)
                end

                add_class(node.identifier.value, {
                    body = node.body,
                    attributes = node.attributes
                }, true, class_path)

                table.insert(data_types, node.identifier.value)

                return node
            end

            if node.type == "IDE" then
                -- INFO: IDENTIFIER

                if v_path then
                    new_scope()

                    local scope = functions
                    for i, v in pairs(v_path) do
                        if v.type == "IDE" then
                            scope[v.value] = {}
                            scope = scope[v.value]
                            local interp = interpret(v)

                            if interp.type == "SET" then
                                for j, k in pairs(copy(list_functions)) do
                                    scope[j] = k
                                end
                            end

                            v_path[i] = v.value
                        end
                    end

                    for i, v in pairs(_path) do
                        if v.type == "NUM" or v.type == "STR" or v.type == "BOL" or v.type == "SET" then
                            add_var(v.value .. "/", v)

                            add_var(v.value .. "/.type", {
                                type = "STR",
                                value = getType(v)
                            })
                            if v.type == "STR" then
                                add_var(v.value .. "/.length", {
                                    type = "NUM",
                                    value = #v.value
                                })
                            elseif v.type == "SET" then
                                add_var(v.value .. "/.length", {
                                    type = "NUM",
                                    value = tostring(get_length(v.elements))
                                })

                                add_func(v.value .. "/", copy(list_functions))
                            end

                            add_var(v.value .. "/.isnum", {
                                type = "BOL",
                                value = v.type == "NUM"
                            })

                            v_path[i] = v_path[i] .. "/"
                        end
                    end

                    local new_path = table.concat(v_path, ".")

                    if scopes[new_path] then
                        if node.value == "length" and scopes[new_path].type ~= "STR" and scopes[new_path].type ~= "SET" then
                            giveError("attempt to get length of " ..  getType(scopes[new_path]) .. " (value has to be string or list)", node.line)
                        end
                    elseif not functions[new_path] then
                        giveError("attempt to call '" .. new_path .. "' never declared", node.line)
                    end

                    new_path = new_path .. "." .. node.value

                    local ret

                    if scopes[new_path] then
                        ret = scopes[new_path]
                    elseif functions[new_path] then
                        ret = {
                            type = "IDE",
                            value = new_path
                        }
                    end

                    if ret then
                        remove_scope()
                        return ret
                    end

                    giveError("attempt to call '" .. new_path .. "' never declared", node.line)
                end

                if scopes[node.value] then
                    return scopes[node.value]
                elseif functions[node.value] then
                    return {
                        type = "IDE",
                        value = node.value,
                        func = functions[node.value]
                    }
                end

                giveError("attempt to call '" .. getValue(node) .. "' never declared", node.line)
            elseif node.type == "CAL" then
                -- INFO: CALL

                local _ide = node.identifier
                local _interp = _ide

                local is_path = false

                if classes[_ide.value] then
                    return {
                        type = "CLS",
                        attributes = classes[_ide.value].attributes,
                        body = classes[_ide.value].body,
                        identifier = _ide
                    }
                end

                new_scope()

                local scope = functions
                if v_path then
                    for i, v in pairs(v_path) do
                        if v.type == "IDE" or type(v) ~= "table" then
                            local _value = v.value
                            if type(v) ~= "table" then
                                _value = ide_path[i].value
                            end

                            if not scope[_value] then
                                if type(v) ~= "table" then
                                    var(ide_path[i], {
                                        type = "IDE",
                                        value = "'" .. v .. "'"
                                    }, false)

                                    v_path[i] = "'" .. v .. "'"
                                end

                                break
                            end
                            if (not scope[_value].push) and type(v) == "table" then
                                v_path[i] = v.value
                                goto continue
                            end

                            if not scope[_value] then
                                scope[_value] = {}
                            end
                            scope = scope[_value]

                            local interp
                            if type(v) == "table" then
                                interp = interpret(v)
                            else
                                interp = interpret(ide_path[i])
                            end

                            if interp.type == "SET" then
                                for j, k in pairs(copy(list_functions)) do
                                    scope[j] = k
                                end
                            end

                            v_path[i] = _value
                        end

                        ::continue::
                    end

                    scope = functions

                    for i, v in pairs(v_path) do
                        if find_index(scope, v) then
                            scope = scope[v]
                        end
                    end

                    if find_index(scope, _ide.value) then
                        is_path = true
                    end
                end

                if not is_path then
                    _interp = interpret(_ide)

                    if _interp.type == "FNC" then
                        add_func(#functions + 1, {
                            body = _interp.body,
                            parameters = _interp.parameters
                        })
                        _interp = {
                            type = "NUM",
                            value = #functions
                        }
                    elseif _interp.func and not functions[_interp.value] then
                        add_func(#functions + 1, {
                            body = _interp.func.body,
                            parameters = _interp.func.parameters
                        })
                        _interp = {
                            type = "NUM",
                            value = #functions
                        }
                    end
                end

                if functions[_interp.value] or is_path then
                    local func = functions[_interp.value]
                    if is_path then
                        func = scope[_interp.value]
                    end

                    local j_path = _ide.value
                    if v_path then
                        j_path = table.concat(v_path, ".") .. "." .. _ide.value
                    end

                    addTrace("in function '" .. j_path .. "'", _ide.line)

                    if v_path then
                        if ins_path and ins_path[1].type == "INS" then
                            var(ins_path[1], {
                                type = "IDE",
                                value = "self"
                            })
                        end
                    end

                    if #func.parameters == 0 and #node.parameters ~= 0 then
                        giveError("function '" .. j_path .. "' requires at least 0 parameters (max 0), got " .. #node.parameters, _ide.line)
                    else
                        if #func.parameters > 0 and func.parameters[#func.parameters].type == "CPM" then
                            if #node.parameters > ((#func.parameters - 1) + func.parameters[#func.parameters].max) then
                                giveError("function '" .. j_path .. "' requires at least " .. #func.parameters - 1 .. " parameters (max " .. ((#func.parameters - 1) + func.parameters[#func.parameters].max) .. "), got " .. #node.parameters, _ide.line)
                            end
                        elseif #node.parameters ~= #func.parameters then
                            if #node.parameters > #func.parameters then
                                giveError("function '" .. j_path .. "' requires at least " .. get_least(func) .. " parameters (max " .. #func.parameters .. "), got " .. #node.parameters, _ide.line)
                            end
                            for i = #node.parameters + 1, #func.parameters do
                                if func.parameters[i].datatypes then
                                    if not find_inval(func.parameters[i].datatypes, "null") then
                                        giveError("function '" .. j_path .. "' requires at least " .. get_least(func) .. " parameters (max " .. #func.parameters .. "), got " .. #node.parameters, _ide.line)
                                    end
                                end
                            end
                        end
                    end

                    for i, v in pairs(func.parameters) do
                        if v.datatypes then
                            for j, k in pairs(v.datatypes) do
                                if not find_value(data_types, k.value) then
                                    giveError("unknown data type '" .. getValue(k) .. "'", k.line)
                                end
                            end
                        end
                    end

                    if func.datatypes then
                        for i, v in pairs(func.datatypes) do
                            if not find_value(data_types, v.value) then
                                giveError("unknown data type '" .. getValue(v) .. "'", v.line)
                            end
                        end
                    end

                    local params = {}
                    for i, v in pairs(node.parameters) do
                        local interp = interpret(v)
                        if func.parameters[i] and func.parameters[i].datatypes then
                            if not find_inval(func.parameters[i].datatypes, getType(interp)) then
                                giveError("parameter " .. i .. " in function '" .. j_path .. "': expected " .. highconcat(func.parameters[i].datatypes, " or ") .. ", got " .. getType(interp), func.parameters[i].line)
                            end
                        end
                        table.insert(params, interp)
                    end

                    for i, v in pairs(func.parameters) do
                        if v.type == "CPM" then
                            local list = {
                                type = "SET",
                                elements = {}
                            }
                            for j = i, #params do
                                list.elements[{
                                    type = "NUM",
                                    value = tostring(get_length(list.elements))
                                }] = params[j]
                            end

                            var(list, v)

                            break
                        else
                            if params[i] then
                                var(params[i], v)
                            else
                                var({
                                    type = "NUL",
                                    value = "null"
                                }, v)
                            end
                        end
                    end

                    if func.body then
                        for i, v in pairs(func.body) do
                            local interp = interpret(v)
                            if interp and interp.type == "RET" then
                                removeTrace()
                                remove_scope()
                                if func.datatypes and (not find_inval(func.datatypes, getType(interp.value))) then
                                    giveError("expected function '" .. _interp.value .. "' to return " .. highconcat(func.datatypes, " or ") .. ", got " .. getType(interp.value), _ide.line)
                                end
                                return interp.value
                            elseif interp and interp.type == "BRK" then
                                removeTrace()
                                remove_scope()
                                return interp
                            elseif interp and interp.type == "CON" then
                                removeTrace()
                                remove_scope()
                                return interp
                            end
                        end
                    else
                        -- INFO: BUILT-IN FUNCTION CALL

                        local ret

                        local _params = {}
                        for i, v in pairs(func.parameters) do
                            table.insert(_params, interpret(v))
                        end

                        if not v_path then
                            -- INFO: PATH:

                            if _interp.value == "line" then
                                -- INFO: LINE

                                new_line = true
                                if _params[1].type == "NUM" then
                                    print(to_int(tonumber(getValue(_params[1]))))
                                elseif _params[1].type ~= "NUL" then
                                    print(getValue(_params[1]))
                                end
                            elseif _interp.value == "write" then
                                -- INFO: WRITE

                                new_line = false
                                if _params[1].type == "NUM" then
                                    io.write(to_int(tonumber(getValue(_params[1]))))
                                elseif _params[1].type ~= "NUL" then
                                    io.write(getValue(_params[1]))
                                end
                            elseif _interp.value == "error" then
                                -- INFO: ERROR

                                new_line = true
                                if _params[1].type == "NUM" then
                                    giveError("" .. tostring(to_int(tonumber(getValue(_params[1])))), _ide.line)
                                elseif _params[1].type ~= "NUL" then
                                    giveError("" .. getValue(_params[1]), _ide.line)
                                end

                                giveError("", _ide.line)
                            end

                            if _interp.value == "input" then
                                -- INFO: INPUT

                                if _params[1].type == "NUM" then
                                    new_line = true

                                    to_int(tonumber(getValue(_params[1])))
                                    ret = {
                                        type = "STR",
                                        value = io.read("*l")
                                    }
                                elseif _params[1].type ~= "NUL" then
                                    new_line = true

                                    io.write(getValue(_params[1]))
                                    ret = {
                                        type = "STR",
                                        value = io.read("*l")
                                    }
                                end
                            end

                            if _interp.value == "type" then
                                -- INFO: TYPE

                                if _params[1] then
                                    ret = {
                                        type = "STR",
                                        value = getType(_params[1])
                                    }
                                else
                                    ret = {
                                        type = "STR",
                                        value = "null"
                                    }
                                end
                            end

                            if _interp.value == "num" then
                                -- INFO: NUM

                                if tonumber(_params[1].value) then
                                    ret = {
                                        type = "NUM",
                                        value = tonumber(_params[1].value)
                                    }
                                else
                                    ret = {
                                        type = "NUL",
                                        value = "null"
                                    }
                                end
                            elseif _interp.value == "str" then
                                -- INFO: STR

                                if _params[1].type == "NUL" then
                                    ret = {
                                        type = "STR",
                                        value = ""
                                    }
                                else
                                    ret = {
                                        type = "STR",
                                        value = _params[1].value
                                    }
                                end
                            end
                        elseif equal_lists(v_path, { "math" }) then
                            -- INFO: PATH: MATH

                            if _interp.value == "random" then
                                -- INFO: MATH.RANDOM

                                ret = {
                                    type = "NUM",
                                    value = tostring(to_int(math.random(tonumber(_params[1].value),
                                        tonumber(_params[2].value))))
                                }

                                if tonumber(_params[2].value) <= tonumber(_params[1].value) then
                                    ret = _params[1]
                                end
                            elseif _interp.value == "clamp" then
                                -- INFO: MATH.CLAMP

                                ret = {
                                    type = "NUM",
                                    value = tostring(clamp(tonumber(_params[1].value), tonumber(_params[2].value),
                                        tonumber(_params[3].value)))
                                }
                            elseif _interp.value == "min" then
                                -- INFO: MATH.MIN

                                ret = _params[1]
                                if tonumber(_params[1].value) < tonumber(_params[2].value) then
                                    ret = params[2]
                                end
                            elseif _interp.value == "max" then
                                -- INFO: MATH.MAX

                                ret = _params[1]
                                if tonumber(_params[1].value) > tonumber(_params[2].value) then
                                    ret = _params[2]
                                end
                            elseif _interp.value == "pow" then
                                -- INFO: MATH.POW

                                ret = {
                                    type = "NUM",
                                    value = tostring(tonumber(_params[1].value) ^ tonumber(_params[2].value))
                                }
                            elseif _interp.value == "abs" then
                                -- INFO: MATH.ABS

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.abs(tonumber(_params[1].value)))
                                }
                            elseif _interp.value == "floor" then
                                -- INFO: MATH.FLOOR

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.floor(tonumber(_params[1].value)))
                                }
                            elseif _interp.value == "ceil" then
                                -- INFO: MATH.CEIL

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.ceil(tonumber(_params[1].value)))
                                }
                            elseif _interp.value == "round" then
                                -- INFO: MATH.ROUND

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.round(tonumber(_params[1].value), tonumber(_params[2].value)))
                                }
                            elseif _interp.value == "sqrt" then
                                -- INFO: MATH.SQRT

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.sqrt(tonumber(_params[1].value)))
                                }
                            elseif _interp.value == "sin" then
                                -- INFO: MATH.SIN

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.sin(tonumber(_params[1].value)))
                                }
                            elseif _interp.value == "cos" then
                                -- INFO: MATH.COS

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.cos(tonumber(_params[1].value)))
                                }
                            elseif _interp.value == "tan" then
                                -- INFO: MATH.TAN

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.tan(tonumber(_params[1].value)))
                                }
                            elseif _interp.value == "ln" then
                                -- INFO: MATH.LN

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.log(tonumber(_params[1].value)))
                                }
                            elseif _interp.value == "log" then
                                -- INFO: MATH.LOG

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.log(tonumber(_params[1].value), tonumber(_params[2].value)))
                                }
                            elseif _interp.value == "rad" then
                                -- INFO: MATH.RAD

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.rad(tonumber(_params[1].value)))
                                }
                            elseif _interp.value == "deg" then
                                -- INFO: MATH.DEG

                                ret = {
                                    type = "NUM",
                                    value = tostring(math.deg(tonumber(_params[1].value)))
                                }
                            end
                        elseif equal_lists(v_path, { "files" }) then
                            -- INFO: PATH: FILES

                            if _interp.value == "open" then
                                -- INFO: FILES.OPEN

                                local _file = io.open(_params[1].value, "r")

                                if _file == nil then
                                    giveError("attempt to open file '" .. _params[1].value .. "' not found", _ide.line)
                                end

                                if _params[2].type ~= "NUL" then
                                    local _s_, _e_ = pcall(function()
                                        _file = io.open(_params[1].value, _params[2].value)
                                    end)

                                    if _e_ then
                                        giveError("attempt to open file '" .. _params[1].value .. "' with invalid mode '" .. _params[2].value .. "'", _ide.line)
                                    end
                                end

                                ret = {
                                    type = "FIL",
                                    value = tostring(_file),
                                    file = _file
                                }
                            elseif _interp.value == "read" then
                                -- INFO: FILES.READ

                                _params[1].file:seek("set", 0)

                                ret = {
                                    type = "STR",
                                    value = tostring(_params[1].file:read("*a"))
                                }
                            elseif _interp.value == "write" then
                                -- INFO: FILES.WRITE

                                _params[1].file:write(_params[2].value)

                                _params[1].file:seek("set", 0)

                                ret = {
                                    type = "STR",
                                    value = tostring(_params[1].file:read("*a"))
                                }
                            end
                        elseif equal_lists(v_path, { "sys" }) then
                            -- INFO: PATH: SYS

                            if _interp.value == "exit" then
                                -- INFO: SYS.EXIT

                                exit()
                            elseif _interp.value == "traceback" then
                                -- INFO: SYS.TRACEBACK

                                ret = {
                                    type = "STR",
                                    value = getTraceback(stack, _ide.line)
                                }

                                if _params[1].type ~= "NUL" then
                                    ret = {
                                        type = "STR",
                                        value = _params[1].value  .. "\n" .. getTraceback(stack, _ide.line)
                                    }
                                end
                            end
                        elseif (scopes[v_path[1]] or scopes[ide_path[1].value]) and #v_path == 1 then
                            -- INFO: PATH: VARIABLE

                            local var_path = interpret({
                                type = "IDE",
                                value = v_path[1]
                            })

                            if find_index(list_functions, _interp) and var_path.type ~= "SET" then
                                giveError("expected list, got " .. getType(var_path), _ide.line)
                            elseif find_index(string_functions, _interp) and var_path.type ~= "STR" then
                                giveError("expected string, got " .. getType(var_path), _ide.line)
                            end

                            if _interp.value == "push" then
                                -- INFO: VAR.PUSH

                                if _params[2].type ~= "NUL" then
                                    local found = false

                                    for i, v in pairs(scopes[v_path[1]].elements) do
                                        if equal_lists(i, {
                                            type = _params[2].type,
                                            value = _params[2].value
                                        }) then
                                            scopes[v_path[1]].elements[i] = _params[1]
                                            found = true
                                            break
                                        end
                                    end

                                    if not found then
                                        scopes[v_path[1]].elements[{
                                            type = _params[2].type,
                                            value = _params[2].value
                                        }] = _params[1]
                                    end
                                else
                                    scopes[v_path[1]].elements[{
                                        type = "NUM",
                                        value = tostring(biggest_digit(var_path.elements))
                                    }] = _params[1]
                                end

                                scopes[v_path[1] .. ".length"] = {
                                    type = "NUM",
                                    value = tostring(get_length(scopes[v_path[1]].elements))
                                }

                                ret = _params[1]
                            elseif _interp.value == "pop" then
                                -- INFO: VAR.POP

                                local n_arr = {}

                                local last = {
                                    type = "NUM",
                                    value = tostring(biggest_digit(var_path.elements) - 1)
                                }

                                if _params[1].type ~= "NUL" then
                                    last = _params[1]
                                end

                                for i, v in pairs(var_path.elements) do
                                    if not equal_lists(i, last) then
                                        n_arr[i] = v
                                    else
                                        last = i
                                    end
                                end

                                if var_path.elements[last] then
                                    ret = var_path.elements[last]
                                else
                                    giveError("attempt to index position '" .. getValue(last) .. "' out of bounds", _ide.line)
                                end

                                scopes[v_path[1]].elements = n_arr
                            elseif _interp.value == "clear" then
                                -- INFO: VAR.CLEAR

                                scopes[v_path[1]].elements = {}

                                ret = {
                                    type = "SET",
                                    elements = {}
                                }
                            elseif _interp.value == "join" then
                                -- INFO: VAR.JOIN

                                local n_str = ""

                                local last

                                local ord_key = {}
                                local ord_value = {}

                                for i, v in pairs(var_path.elements) do
                                    table.insert(ord_key, i)
                                end
                                table.sort(ord_key, function(x, y)
                                    if (not tonumber(x.value)) or (not tonumber(y.value)) then
                                        return x.value < y.value
                                    end
                                    return tonumber(x.value) < tonumber(y.value)
                                end)

                                for i, v in pairs(ord_key) do
                                    table.insert(ord_value, var_path.elements[v])
                                end

                                for i, v in pairs(ord_key) do
                                    last = v
                                end

                                for i, v in pairs(ord_key) do
                                    if ord_value[i].type ~= "STR" then
                                        giveError("attempt to join " .. getType(ord_value[i]) .. " with string", _ide.line)
                                    end

                                    n_str = n_str .. ord_value[i].value
                                    if v ~= last then
                                        n_str = n_str .. _params[1].value
                                    end
                                end

                                ret = {
                                    type = "STR",
                                    value = n_str
                                }
                            elseif _interp.value == "has" then
                                -- INFO: VAR.HAS

                                if var_path.type == "SET" then
                                    for i, v in pairs(var_path.elements) do
                                        if v.type == _params[1].type and v.value == _params[1].value then
                                            ret = {
                                                type = "BOL",
                                                value = "true"
                                            }
                                        end
                                    end

                                    ret = {
                                        type = "BOL",
                                        value = "false"
                                    }
                                else
                                    ret = {
                                        type = "BOL",
                                        value = "false"
                                    }

                                    for i = 1, #var_path.value do
                                        local chunk = string.sub(var_path.value, i, (i - 1) + #_params[1].value)

                                        if chunk == _params[1].value then
                                            ret = {
                                                type = "BOL",
                                                value = "true"
                                            }

                                            break
                                        end
                                    end
                                end
                            elseif _interp.value == "reverse" then
                                -- INFO: VAR.REVERSE

                                if var_path.type == "SET" then
                                    local n_arr = {}

                                    local ord_key = {}
                                    local ord_value = {}

                                    for i, v in pairs(var_path.elements) do
                                        table.insert(ord_key, i)
                                    end
                                    table.sort(ord_key, function(x, y)
                                        if (not tonumber(x.value)) or (not tonumber(y.value)) then
                                            return x.value < y.value
                                        end
                                        return tonumber(x.value) < tonumber(y.value)
                                    end)

                                    local n_key = {}

                                    for i, v in pairs(ord_key) do
                                        table.insert(n_key, 1, v)
                                        table.insert(ord_value, var_path.elements[v])
                                    end

                                    for i, v in pairs(n_key) do
                                        n_arr[v] = ord_value[i]
                                    end

                                    scopes[v_path[1]].elements = n_arr

                                    ret = {
                                        type = "SET",
                                        elements = n_arr
                                    }
                                elseif var_path.type == "STR" then
                                    ret = {
                                        type = "STR",
                                        value = string.reverse(var_path.value)
                                    }
                                end
                            elseif _interp.value == "split" then
                                -- INFO: VAR.SPLIT

                                local n_str = {}

                                local chunk = ""
                                local skip_index = 0
                                for i = 1, #var_path.value do
                                    if skip_index > i then
                                        goto continue
                                    end

                                    local n_chunk = string.sub(var_path.value, i, (i - 1) + #_params[1].value)

                                    if n_chunk == _params[1].value then
                                        if _params[1].value == "" then
                                            chunk = chunk .. string.sub(var_path.value, i, i)
                                        end

                                        table.insert(n_str, {
                                            type = "STR",
                                            value = chunk
                                        })
                                        skip_index = i  + #_params[1].value
                                        chunk = ""
                                    else
                                        chunk = chunk .. string.sub(var_path.value, i, i)
                                    end

                                    ::continue::
                                end
                                if chunk ~= "" then
                                    table.insert(n_str, {
                                        type = "STR",
                                        value = chunk
                                    })
                                end

                                local n_arr = {}
                                for i, v in pairs(n_str) do
                                    if tonumber(i) then
                                        n_arr[{
                                            type = "NUM",
                                            value = tostring(tonumber(i) - 1)
                                        }] = v
                                    else
                                        n_arr[i] = v
                                    end
                                end

                                ret = {
                                    type = "SET",
                                    elements = n_arr
                                }
                            elseif _interp.value == "upper" then
                                -- INFO: VAR.UPPER

                                ret = {
                                    type = "STR",
                                    value = string.upper(var_path.value)
                                }
                            elseif _interp.value == "lower" then
                                -- INFO: VAR.LOWER

                                ret = {
                                    type = "STR",
                                    value = string.lower(var_path.value)
                                }
                            end
                        end

                        removeTrace()

                        remove_scope()

                        return ret
                    end

                    removeTrace()

                    remove_scope()

                    return
                end

                giveError("attempt to call '" .. getValue(_interp) .. "' never declared", _ide.line)
            end

            if node.type == "RET" then
                -- INFO: RETURN

                return {
                    type = "RET",
                    value = interpret(node.value)
                }
            elseif node.type == "BRK" or node.type == "CON" then
                -- INFO: BREAK

                return node
            end

            if node.type == "SET" then
                -- INFO: ARRAY

                local interp_elements = {}

                for i, v in pairs(node.elements) do
                    local interp = interpret(i)
                    local v_interp = interpret(v)

                    if interp.type ~= "NUL" and v_interp.type ~= "NUL" then
                        interp_elements[interp] = v_interp
                    end
                end

                return {
                    type = "SET",
                    elements = interp_elements
                }
            elseif node.type == "IDX" then
                -- INFO: INDEX

                local _ide = interpret(node.identifier, _path, ide_path)

                local interp = interpret(node.index)

                if _ide.type == "STR" then
                    if interp.type ~= "NUM" then
                        giveError("attempt to index a value '" .. getValue(interp) .. "' out of bounds", interp.line)
                    end
                    if (tonumber(interp.value) >= #_ide.value) or (tonumber(interp.value) < (0 - #_ide.value)) then
                        return {
                            type = "STR",
                            value = ""
                        }
                    end

                    if tonumber(interp.value) ~= math.round(tonumber(interp.value)) then
                        giveError("expected integer for indexing a string, got " .. getType(interp), interp.line)
                    end

                    return {
                        type = "STR",
                        value = string.sub(_ide.value, tonumber(interp.value) % (#_ide.value) + 1, tonumber(interp.value) % (#_ide.value) + 1)
                    }
                end

                if _ide.type ~= "SET" then
                    giveError("attempt to index a " .. getType(_ide))
                end

                local index = find_index(_ide.elements, interp)

                if index == nil then
                    giveError("attempt to index a value '" .. getValue(interp) .. "' out of bounds", interp.line)
                end

                return index
            end

            if node.type == "PTH" then
                -- INFO: PATH

                local _ide = _path or {}
                local _ide_path = ide_path or {}

                local interp = interpret(node.identifier)

                local _ins_path = ins_path

                if interp.type == "SET" or interp.type == "INS" or interp.type == "CLS" then
                    if interp.type == "CLS" then
                        table.insert(_ide, interp.identifier)

                        _ins_path = ins_path or {}
                        table.insert(_ins_path, new_instance(node.identifier, interp, interp.identifier))
                    else
                        table.insert(_ide, node.identifier)
                    end

                    if interp.type == "INS" then
                        _ins_path = ins_path or {}
                        table.insert(_ins_path, interp)
                    end
                else
                    table.insert(_ide, interp)
                    table.insert(_ide_path, node.identifier)
                end

                return interpret(node.path, _ide, _ide_path, class_path, _ins_path)
            end
        end

        for i, v in pairs(ast) do
            interpret(v)
        end
    end

    function parser(code)
        -- INFO: PARSER
        function bool(tokens)
            -- INFO: BOOL
            local _left = logic(tokens)

            if #tokens == 0 then
                return _left
            end

            if tokens[1].type == "INF" then
                local _type = table.remove(tokens, 1).type

                if tokens[1].type == "EQL" then
                    table.remove(tokens, 1)

                    return {
                        type = "IQL",
                        left = _left,
                        right = bool(tokens)
                    }
                end

                return {
                    type = _type,
                    left = _left,
                    right = bool(tokens)
                }
            elseif tokens[1].type == "SUP" then
                local _type = table.remove(tokens, 1).type

                if tokens[1].type == "EQL" then
                    table.remove(tokens, 1)

                    return {
                        type = "SQL",
                        left = _left,
                        right = bool(tokens)
                    }
                end

                return {
                    type = _type,
                    left = _left,
                    right = bool(tokens)
                }
            elseif tokens[1].type == "EQL" then
                local _type = tokens[1].type

                if tokens[2].type == "EQL" then
                    table.remove(tokens, 1)
                    table.remove(tokens, 1)

                    return {
                        type = _type,
                        left = _left,
                        right = bool(tokens)
                    }
                end
            elseif #tokens > 1 and tokens[1].type == "EXC" and tokens[2].type == "EQL" then
                table.remove(tokens, 1)
                table.remove(tokens, 1)

                return {
                    type = "NQL",
                    left = _left,
                    right = bool(tokens)
                }
            end

            return _left
        end

        function logic(tokens)
            -- INFO: LOGIC
            if #tokens > 0 and tokens[1].type == "EXC" then
                if not (#tokens > 0 and tokens[2].type == "EQL") then
                    return {
                        type = table.remove(tokens, 1).type,
                        value = logic(tokens)
                    }
                end
            end

            local _left = terms(tokens)

            if #tokens == 0 then
                return _left
            end

            if tokens[1].type == "BAR" or tokens[1].type == "AND" or tokens[1].type == "XOR" then
                return {
                    type = table.remove(tokens, 1).type,
                    left = _left,
                    right = logic(tokens)
                }
            end

            return _left
        end

        function terms(tokens)
            -- INFO: TERMS
            local _left = factors(tokens)

            if #tokens == 0 then
                return _left
            end

            if tokens[1].type == "ADD" or tokens[1].type == "SUB" then
                return {
                    type = table.remove(tokens, 1).type,
                    left = _left,
                    right = terms(tokens)
                }
            end

            return _left
        end

        function factors(tokens)
            -- INFO: FACTORS
            local _left = paren(tokens)

            if #tokens == 0 then
                return _left
            end

            if tokens[1].type == "MLT" or tokens[1].type == "DIV" or tokens[1].type == "PRC" then
                return {
                    type = table.remove(tokens, 1).type,
                    left = _left,
                    right = factors(tokens)
                }
            end

            return _left
        end

        function paren(tokens)
            -- INFO: PARENTHESES
            if #tokens == 0 then
                return format(tokens)
            end

            if tokens[1].type == "LPA" then
                table.remove(tokens, 1)

                local _in = bool(tokens)

                if #tokens == 0 then
                    giveError("missing ')' to close '('")
                end

                if tokens[1].type == "RPA" then
                    table.remove(tokens, 1)

                    return _in
                end

                giveError("missing ')' to close '(' near '" .. getValue(tokens[1]) .. "'", tokens[1].line)
            end

            return format(tokens)
        end

        function format(tokens)
            -- INFO: FORMAT
            if #tokens > 0 and tokens[1].type == "DOL" then
                return {
                    type = table.remove(tokens, 1).type,
                    value = format(tokens)
                }
            end

            return literal(tokens)
        end

        function literal(tokens)
            -- INFO: LITERAL
            if #tokens == 0 then
                return {
                    type = "NUL",
                    value = "null"
                }
            end

            if #tokens > 2 and tokens[2].type == "DOT" and tokens[3].type == "IDE" then
                -- INFO: PATH

                table.remove(tokens, 2)

                return {
                    type = "PTH",
                    identifier = table.remove(tokens, 1),
                    path = literal(tokens)
                }
            end

            if tokens[1].type == "IDE" then
                -- INFO: IDENTIFIER
                if #tokens > 1 then
                    if tokens[2].type == "LPA" then
                        local _ide = table.remove(tokens, 1)
                        table.remove(tokens, 1)

                        if #tokens == 0 then
                            giveError("missing ')' to close '('")
                        end

                        local params = {}

                        if tokens[1].type ~= "RPA" then
                            while #tokens > 0 do
                                table.insert(params, parse(tokens, {}, false)[1])

                                if #tokens == 0 then
                                    giveError("missing ')' to close '('")
                                end

                                if tokens[1].type == "COM" then
                                    table.remove(tokens, 1)
                                    goto continue
                                end
                                if tokens[1].type == "RPA" then
                                    break
                                end
                                giveError("missing ')' to close '(' near '" .. getValue(tokens[1]) .. "'", tokens[1].line)

                                ::continue::
                            end
                        end
                        if #tokens == 0 then
                            giveError("missing ')' to close '('")
                        end
                        table.remove(tokens, 1)

                        if _ide.value == "for" then
                            -- INFO: FOR LOOP

                            if #params ~= 3 then
                                giveError("expected 3 parameters for defining a for loop", tokens[1].line)
                            end

                            if tokens[1].type ~= "LBR" then
                                giveError("missing body for the for loop", tokens[1].line)
                            end
                            table.remove(tokens, 1)

                            local _body = {}
                            local s_index = 0

                            if tokens[1].type ~= "RBR" then
                                while #tokens > 0 do
                                    table.insert(_body, table.remove(tokens, 1))

                                    if tokens[1].type == "LBR" then
                                        s_index = s_index + 1
                                    end

                                    if tokens[1].type == "RBR" and s_index == 0 then
                                        break
                                    elseif tokens[1].type == "RBR" then
                                        s_index = s_index - 1
                                    end
                                end
                            end
                            if #tokens == 0 then
                                giveError("missing '}' to close '{'")
                            end
                            table.remove(tokens, 1)

                            return {
                                type = "FOR",
                                parameters = params,
                                body = parse(_body, {}, true)
                            }
                        end

                        if _ide.value == "foreach" then
                            -- INFO: FOREACH LOOP

                            if #params > 2 or #params == 0 then
                                giveError("expected 1 or 2 parameters for defining a foreach loop", tokens[1].line)
                            end

                            if tokens[1].type ~= "IDE" or tokens[1].value ~= "in" then
                                giveError("expected 'in' to define foreach loop", tokens[1].line)
                            end
                            table.remove(tokens, 1)

                            if tokens[1].type ~= "IDE" then
                                giveError("expected list to loop through for foreach loop", tokens[1].line)
                            end
                            local _list = parse(tokens, {}, false)[1]

                            if tokens[1].type ~= "LBR" then
                                giveError("missing body for the foreach loop", tokens[1].line)
                            end
                            table.remove(tokens, 1)

                            local _body = {}
                            local s_index = 0

                            if tokens[1].type ~= "RBR" then
                                while #tokens > 0 do
                                    table.insert(_body, table.remove(tokens, 1))

                                    if tokens[1].type == "LBR" then
                                        s_index = s_index + 1
                                    end

                                    if tokens[1].type == "RBR" and s_index == 0 then
                                        break
                                    elseif tokens[1].type == "RBR" then
                                        s_index = s_index - 1
                                    end
                                end
                            end
                            if #tokens == 0 then
                                giveError("missing '}' to close '{'")
                            end
                            table.remove(tokens, 1)

                            return {
                                type = "FRC",
                                parameters = params,
                                body = parse(_body, {}, true),
                                list = _list
                            }
                        end

                        if _ide.value == "while" then
                            -- INFO: WHILE LOOP

                            if #params ~= 1 then
                                giveError("expected 1 parameter for defining a while loop", tokens[1].line)
                            end

                            if tokens[1].type ~= "LBR" then
                                giveError("missing body for the whiles loop", tokens[1].line)
                            end
                            table.remove(tokens, 1)

                            if tokens[1].type == "RBR" then
                                table.remove(tokens, 1)
                                return {
                                    type = "WHL",
                                    condition = params[1],
                                    body = {}
                                }
                            end

                            local _body = {}
                            local s_index = 0

                            if tokens[1].type ~= "RBR" then
                                while #tokens > 0 do
                                    table.insert(_body, table.remove(tokens, 1))

                                    if tokens[1].type == "LBR" then
                                        s_index = s_index + 1
                                    end

                                    if tokens[1].type == "RBR" and s_index == 0 then
                                        break
                                    elseif tokens[1].type == "RBR" then
                                        s_index = s_index - 1
                                    end
                                end
                            end
                            if #tokens == 0 then
                                giveError("missing '}' to close '{'")
                            end
                            table.remove(tokens, 1)

                            return {
                                type = "WHL",
                                condition = params[1],
                                body = parse(_body, {}, true)
                            }
                        end

                        if _ide.value == "repeat" then
                            -- INFO: REPEAT LOOP

                            if #params ~= 1 then
                                giveError("expected 1 parameter for defining a repeat loop", tokens[1].line)
                            end

                            if tokens[1].type ~= "LBR" then
                                giveError("missing body for the for loop", tokens[1].line)
                            end
                            table.remove(tokens, 1)

                            if tokens[1].type == "RBR" then
                                table.remove(tokens, 1)
                                return {
                                    type = "RPT",
                                    amount = params[1],
                                    body = {}
                                }
                            end

                            local _body = {}
                            local s_index = 0

                            if tokens[1].value ~= "RBR" then
                                while #tokens > 0 do
                                    table.insert(_body, table.remove(tokens, 1))

                                    if tokens[1].type == "LBR" then
                                        s_index = s_index + 1
                                    end

                                    if tokens[1].type == "RBR" and s_index == 0 then
                                        break
                                    elseif tokens[1].type == "RBR" then
                                        s_index = s_index - 1
                                    end
                                end
                            end
                            if #tokens == 0 then
                                giveError("missing '}' to close '{'")
                            end
                            table.remove(tokens, 1)

                            return {
                                type = "RPT",
                                amount = params[1],
                                body = parse(_body, {}, true)
                            }
                        end

                        if _ide.value == "if" then
                            -- INFO: IF STATEMENT

                            if #params ~= 1 then
                                giveError("expected 1 parameter for defining an if statement", tokens[1].line)
                            end

                            if tokens[1].type ~= "LBR" then
                                giveError("missing body for the if statement", tokens[1].line)
                            end
                            table.remove(tokens, 1)

                            local _body = {}
                            local s_index = 0

                            if tokens[1].type ~= "RBR" then
                                while #tokens > 0 do
                                    table.insert(_body, table.remove(tokens, 1))

                                    if tokens[1].type == "LBR" then
                                        s_index = s_index + 1
                                    end

                                    if tokens[1].type == "RBR" and s_index == 0 then
                                        break
                                    elseif tokens[1].type == "RBR" then
                                        s_index = s_index - 1
                                    end
                                end
                            end
                            if #tokens == 0 then
                                giveError("missing '}' to close '{'")
                            end
                            table.remove(tokens, 1)

                            if #tokens > 0 then
                                if tokens[1].type == "IDE" then
                                    if tokens[1].value == "else" then
                                        -- INFO: ELSE STATEMENT

                                        table.remove(tokens, 1)

                                        if tokens[1].type ~= "LBR" then
                                            giveError("missing body for the else statement", tokens[1].line)
                                        end
                                        table.remove(tokens, 1)

                                        local _else_body = {}
                                        s_index = 0

                                        if tokens[1].type ~= "RBR" then
                                            while #tokens > 0 do
                                                table.insert(_else_body, table.remove(tokens, 1))

                                                if tokens[1].type == "LBR" then
                                                    s_index = s_index + 1
                                                end

                                                if tokens[1].type == "RBR" and s_index == 0 then
                                                    break
                                                elseif tokens[1].type == "RBR" then
                                                    s_index = s_index - 1
                                                end
                                            end
                                        end
                                        if #tokens == 0 then
                                            giveError("missing '}' to close '{'")
                                        end
                                        table.remove(tokens, 1)

                                        return {
                                            type = "IFS",
                                            condition = params[1],
                                            body = parse(_body, {}, true),
                                            else_body = parse(_else_body, {}, true)
                                        }
                                    end

                                    if tokens[1].value == "elif" then
                                        -- INFO: ELIF STATEMENT

                                        tokens[1] = {
                                            type = "IDE",
                                            value = "if"
                                        }

                                        return {
                                            type = "IFS",
                                            condition = params[1],
                                            body = parse(_body, {}, true),
                                            else_body = parse(tokens, {}, false)
                                        }
                                    end
                                end
                            end

                            return {
                                type = "IFS",
                                condition = params[1],
                                body = parse(_body, {}, true)
                            }
                        end

                        if #tokens > 1 and tokens[1].type == "LPA" then
                            if type(_ide.value) == "table" then
                                if #tokens > 1 and tokens[1].type == "DOT" and tokens[2].type == "IDE" then
                                    table.remove(tokens, 1)

                                    table.insert(tokens, 1, {
                                        type = "PTH",
                                        identifier = {
                                            type = "IDE",
                                            value = {
                                                type = "CAL",
                                                identifier = _ide.value,
                                                parameters = params
                                            }
                                        },
                                        path = literal(tokens)
                                    })
                                else
                                    table.insert(tokens, 1, {
                                        type = "IDE",
                                        value = {
                                            type = "CAL",
                                            identifier = _ide.value,
                                            parameters = params
                                        }
                                    })
                                end

                                return parse(tokens, {}, false)[1]
                            end
                            if #tokens > 1 and tokens[1].type == "DOT" and tokens[2].type == "IDE" then
                                table.remove(tokens, 1)

                                table.insert(tokens, 1, {
                                    type = "PTH",
                                    identifier = {
                                        type = "IDE",
                                        value = {
                                            type = "CAL",
                                            identifier = _ide,
                                            parameters = params
                                        }
                                    },
                                    path = literal(tokens)
                                })
                            else
                                table.insert(tokens, 1, {
                                    type = "IDE",
                                    value = {
                                        type = "CAL",
                                        identifier = _ide,
                                        parameters = params
                                    }
                                })
                            end

                            return parse(tokens, {}, false)[1]
                        end

                        if type(_ide.value) == "table" then
                            if #tokens > 1 and tokens[1].type == "DOT" and tokens[2].type == "IDE" then
                                table.remove(tokens, 1)

                                return {
                                    type = "PTH",
                                    identifier = {
                                        type = "CAL",
                                        identifier = _ide.value,
                                        parameters = params
                                    },
                                    path = literal(tokens)
                                }
                            end

                            return {
                                type = "CAL",
                                identifier = _ide.value,
                                parameters = params
                            }
                        end

                        if #tokens > 1 and tokens[1].type == "DOT" and tokens[2].type == "IDE" then
                            table.remove(tokens, 1)

                            return {
                                type = "PTH",
                                identifier = {
                                    type = "CAL",
                                    identifier = _ide,
                                    parameters = params
                                },
                                path = literal(tokens)
                            }
                        end

                        return {
                            type = "CAL",
                            identifier = _ide,
                            parameters = params
                        }
                    end

                    if tokens[2].type == "EQL" then
                        if #tokens > 2 then
                            if tokens[3].type ~= "EQL" then
                                -- INFO: VARIABLE ASSIGNMENT

                                table.remove(tokens, 2)

                                if #tokens > 1 and tokens[2].type == "IDE" and tokens[2].value == "func" and tokens[3].type == "LPA" then
                                    tokens[2] = tokens[1]

                                    tokens[1] = {
                                        type = "IDE",
                                        value = "func"
                                    }

                                    return parse(tokens, {}, false)[1]
                                elseif #tokens > 1 and tokens[2].type == "IDE" and tokens[2].value == "class" and tokens[3].type == "LPA" then
                                    tokens[2] = tokens[1]

                                    tokens[1] = {
                                        type = "IDE",
                                        value = "class"
                                    }

                                    return parse(tokens, {}, false)[1]
                                end

                                return {
                                    type = "ASN",
                                    identifier = table.remove(tokens, 1),
                                    value = parse(tokens, {}, false)[1]
                                }
                            end
                        else
                            giveError("attempt to give undefined value to variable '" .. getValue(tokens[1]) .. "'", tokens[1].line)
                        end
                    elseif #tokens > 2 and tokens[2].type == "INF" then
                        local n_tokens = copy(tokens)

                        local _datatypes

                        local _ide = table.remove(n_tokens, 1)
                        table.remove(n_tokens, 1)

                        local found_dt = false

                        _datatypes = {}
                        while #n_tokens > 0 do
                            table.insert(_datatypes, table.remove(n_tokens, 1))

                            if n_tokens[1].type == "BAR" then
                                table.remove(n_tokens, 1)
                                goto continue
                            end
                            if n_tokens[1].type == "SUP" then
                                found_dt = true
                            end
                            do
                                break
                            end

                            ::continue::
                        end

                        table.remove(n_tokens, 1)
                        if #n_tokens > 0 and found_dt and n_tokens[1].type == "EQL" then
                            if #n_tokens > 1 then
                                if n_tokens[2].type ~= "EQL" then
                                    -- INFO: STATIC TYPED VARIABLE ASSIGNMENT

                                    table.remove(n_tokens, 1)

                                    tokens = table.clear(tokens)
                                    for i, v in pairs(n_tokens) do
                                        table.insert(tokens, copy(v))
                                    end

                                    return {
                                        type = "ASN",
                                        identifier = _ide,
                                        value = parse(tokens, {}, false)[1],
                                        datatypes = _datatypes
                                    }
                                end
                            else
                                giveError("attempt to give undefined value to variable '" .. getValue(_ide) .. "'", _ide.line)
                            end
                        end
                    end

                    if #tokens > 2 and tokens[2].type == "COL" and tokens[3].type == "EQL" then
                        if #tokens > 3 then
                            if tokens[4].type ~= "EQL" then
                                -- INFO: GLOBAL VARIABLE DECLARATION

                                table.remove(tokens, 2)
                                table.remove(tokens, 2)

                                if #tokens > 1 and tokens[2].type == "IDE" and tokens[2].value == "func" and tokens[3].type == "LPA" then
                                    tokens[2] = tokens[1]

                                    tokens[1] = {
                                        type = "IDE",
                                        value = "func"
                                    }

                                    local func = parse(tokens, {}, false)[1]
                                    func.type = "GFN"

                                    return func
                                elseif #tokens > 1 and tokens[2].type == "IDE" and tokens[2].value == "class" and tokens[3].type == "LPA" then
                                    tokens[2] = tokens[1]

                                    tokens[1] = {
                                        type = "IDE",
                                        value = "class"
                                    }

                                    local class = parse(tokens, {}, false)[1]
                                    class.type = "GCL"

                                    return class
                                end

                                return {
                                    type = "GSN",
                                    identifier = table.remove(tokens, 1),
                                    value = parse(tokens, {}, false)[1]
                                }
                            end
                        else
                            giveError("attempt to give undefined value to global variable '" .. getValue(tokens[1]) .. "'", tokens[1].line)
                        end
                    elseif #tokens > 2 and tokens[2].type == "INF" then
                        local n_tokens = copy(tokens)

                        local _datatypes

                        local _ide = table.remove(n_tokens, 1)
                        table.remove(n_tokens, 1)

                        local found_dt = false

                        _datatypes = {}
                        while #n_tokens > 0 do
                            table.insert(_datatypes, table.remove(n_tokens, 1))

                            if n_tokens[1].type == "BAR" then
                                table.remove(n_tokens, 1)
                                goto continue
                            end
                            if n_tokens[1].type == "SUP" then
                                found_dt = true
                            end
                            do
                                break
                            end

                            ::continue::
                        end

                        table.remove(n_tokens, 1)
                        if #n_tokens > 1 and found_dt and n_tokens[2].type == "EQL" then
                            if #n_tokens > 2 then
                                if n_tokens[3].type ~= "EQL" then
                                    -- INFO: STATIC TYPED GLOBAL VARIABLE ASSIGNMENT

                                    table.remove(n_tokens, 1)
                                    table.remove(n_tokens, 1)

                                    tokens = table.clear(tokens)
                                    for i, v in pairs(n_tokens) do
                                        table.insert(tokens, copy(v))
                                    end

                                    return {
                                        type = "GSN",
                                        identifier = _ide,
                                        value = parse(tokens, {}, false)[1],
                                        datatypes = _datatypes
                                    }
                                end
                            else
                                giveError("attempt to give undefined value to variable '" .. getValue(_ide) .. "'", _ide.line)
                            end
                        end
                    end

                    if (tokens[2].type == "ADD" and tokens[3].type == "ADD") or (tokens[2].type == "SUB" and tokens[3].type == "SUB") then
                        -- INFO: VARIABLE + OR - 1

                        local _type = table.remove(tokens, 2).type
                        table.remove(tokens, 2)

                        local _ide = table.remove(tokens, 1)

                        return {
                            type = "ASN",
                            identifier = _ide,
                            value = {
                                type = _type,
                                left = _ide,
                                right = {
                                    type = "NUM",
                                    value = "1"
                                }
                            }
                        }
                    end
                end

                if tokens[1].value == "func" then
                    -- INFO: FUNCTION DECLARATION

                    table.remove(tokens, 1)

                    if tokens[1].type ~= "IDE" then
                        giveError("expected identifier to define a function", tokens[1].line)
                    end
                    local _ide = table.remove(tokens, 1)

                    if tokens[1].type ~= "LPA" then
                        giveError("expected parameters to define a function", tokens[1].line)
                    end
                    table.remove(tokens, 1)

                    if #tokens == 0 then
                        giveError("missing ')' to close '('")
                    end

                    local params = {}
                    if tokens[1].type ~= "RPA" then
                        while #tokens > 0 do
                            table.insert(params, table.remove(tokens, 1))
                            if params[#params].type ~= "IDE" then
                                giveError("parameter " .. #params .. " in function has to be an identifier, got " .. getType(params[#params]), tokens[1].line)
                            end

                            if tokens[1].type == "INF" then
                                table.remove(tokens, 1)

                                params[#params].datatypes = {}
                                local datatypes = params[#params].datatypes

                                while #tokens > 0 do
                                    table.insert(datatypes, table.remove(tokens, 1))

                                    if tokens[1].type == "BAR" then
                                        table.remove(tokens, 1)
                                        goto _continue
                                    end
                                    if tokens[1].type == "SUP" then
                                        break
                                    end
                                    giveError("missing '>' to close '<' near '" .. getValue(tokens[1]) .. "'",
                                    tokens[1].line)

                                    ::_continue::
                                end
                                if #tokens == 0 then
                                    giveError("missing '>' to close '<'")
                                end
                                table.remove(tokens, 1)
                            elseif #tokens > 2 and tokens[1].type == "DOT" and tokens[2].type == "DOT" and tokens[3].type == "DOT" then
                                table.remove(tokens, 1)
                                table.remove(tokens, 1)
                                table.remove(tokens, 1)

                                if #tokens > 0 and tokens[1].type == "NUM" then
                                    params[#params] = {
                                        type = "CPM",
                                        value = params[#params].value,
                                        max = table.remove(tokens, 1).value
                                    }
                                else
                                    params[#params] = {
                                        type = "CPM",
                                        value = params[#params].value,
                                        max = math.huge
                                    }
                                end

                                if tokens[1].type == "RPA" then
                                    break
                                end
                                giveError("missing ')' to close '(' near '" .. getValue(tokens[1]) .. "'", tokens[1].line)
                            end

                            if tokens[1].type == "COM" then
                                table.remove(tokens, 1)
                                goto continue
                            end
                            if tokens[1].type == "RPA" then
                                break
                            end
                            giveError("missing ')' to close '(' near '" .. getValue(tokens[1]) .. "'", tokens[1].line)

                            ::continue::
                        end
                    end
                    if #tokens == 0 then
                        giveError("missing ')' to close '('")
                    end
                    table.remove(tokens, 1)

                    local _datatypes

                    if tokens[1].type == "INF" then
                        table.remove(tokens, 1)

                        _datatypes = {}
                        while #tokens > 0 do
                            table.insert(_datatypes, table.remove(tokens, 1))

                            if tokens[1].type == "BAR" then
                                table.remove(tokens, 1)
                                goto continue
                            end
                            if tokens[1].type == "SUP" then
                                break
                            end
                            giveError("missing '>' to close '<' near '" .. getValue(tokens[1]) .. "'", tokens[1].line)

                            ::continue::
                        end
                        if #tokens == 0 then
                            giveError("missing '>' to close '<'")
                        end
                        table.remove(tokens, 1)
                    end

                    if tokens[1].type ~= "LBR" then
                        giveError("missing body for the function " .. getValue(_ide), tokens[1].line)
                    end
                    table.remove(tokens, 1)

                    local _body = {}
                    local s_index = 0

                    if tokens[1].type ~= "RBR" then
                        while #tokens > 0 do
                            table.insert(_body, table.remove(tokens, 1))

                            if tokens[1].type == "LBR" then
                                s_index = s_index + 1
                            end

                            if tokens[1].type == "RBR" and s_index == 0 then
                                break
                            elseif tokens[1].type == "RBR" then
                                s_index = s_index - 1
                            end
                        end
                    end
                    if #tokens == 0 then
                        giveError("missing '}' to close '{'")
                    end
                    table.remove(tokens, 1)

                    return {
                        type = "FNC",
                        parameters = params,
                        body = parse(_body, {}, true),
                        identifier = _ide,
                        datatypes = _datatypes
                    }
                elseif tokens[1].value == "class" then
                    -- INFO: CLASS DECLARATION

                    table.remove(tokens, 1)

                    if tokens[1].type ~= "IDE" then
                        giveError("expected identifier to define a class", tokens[1].line)
                    end
                    local _ide = table.remove(tokens, 1)

                    if tokens[1].type ~= "LPA" then
                        giveError("expected attributes to define a class", tokens[1].line)
                    end
                    table.remove(tokens, 1)

                    if #tokens == 0 then
                        giveError("missing ')' to close '('")
                    end

                    local attribs = {}
                    if tokens[1].type ~= "RPA" then
                        while #tokens > 0 do
                            table.insert(attribs, table.remove(tokens, 1))
                            if attribs[#attribs].type ~= "IDE" then
                                giveError("attribute " .. #attribs .. " in class has to be an identifier, got " .. getType(attribs[#attribs]), tokens[1].line)
                            end

                            if tokens[1].type == "INF" then
                                table.remove(tokens, 1)

                                attribs[#attribs].datatypes = {}
                                local datatypes = attribs[#attribs].datatypes

                                while #tokens > 0 do
                                    table.insert(datatypes, table.remove(tokens, 1))

                                    if tokens[1].type == "BAR" then
                                        table.remove(tokens, 1)
                                        goto _continue
                                    end
                                    if tokens[1].type == "SUP" then
                                        break
                                    end
                                    giveError("missing '>' to close '<' near '" .. getValue(tokens[1]) .. "'", tokens[1].line)

                                    ::_continue::
                                end
                                if #tokens == 0 then
                                    giveError("missing '>' to close '<'")
                                end
                                table.remove(tokens, 1)
                            elseif #tokens > 2 and tokens[1].type == "DOT" and tokens[2].type == "DOT" and tokens[3].type == "DOT" then
                                table.remove(tokens, 1)
                                table.remove(tokens, 1)
                                table.remove(tokens, 1)

                                if #tokens > 0 and tokens[1].type == "NUM" then
                                    attribs[#attribs] = {
                                        type = "CPM",
                                        value = attribs[#attribs].value,
                                        max = table.remove(tokens, 1).value
                                    }
                                else
                                    attribs[#attribs] = {
                                        type = "CPM",
                                        value = attribs[#attribs].value,
                                        max = math.huge
                                    }
                                end

                                if tokens[1].type == "RPA" then
                                    break
                                end
                                giveError("missing ')' to close '(' near '" .. getValue(tokens[1]) .. "'", tokens[1].line)
                            end

                            if tokens[1].type == "COM" then
                                table.remove(tokens, 1)
                                goto continue
                            end
                            if tokens[1].type == "RPA" then
                                break
                            end
                            giveError("missing ')' to close '(' near ''" .. getValue(tokens[1]) .. "'", tokens[1].line)

                            ::continue::
                        end
                    end
                    if #tokens == 0 then
                        giveError("missing ')' to close '('")
                    end
                    table.remove(tokens, 1)

                    if tokens[1].type ~= "LBR" then
                        giveError("missing body for the function " .. getValue(_ide), tokens[1].line)
                    end
                    table.remove(tokens, 1)

                    local _body = {}
                    local s_index = 0

                    if tokens[1].type ~= "RBR" then
                        while #tokens > 0 do
                            table.insert(_body, table.remove(tokens, 1))

                            if tokens[1].type == "LBR" then
                                s_index = s_index + 1
                            end

                            if tokens[1].type == "RBR" and s_index == 0 then
                                break
                            elseif tokens[1].type == "RBR" then
                                s_index = s_index - 1
                            end
                        end
                    end
                    if #tokens == 0 then
                        giveError("missing '}' to close '{'")
                    end
                    table.remove(tokens, 1)

                    return {
                        type = "CLS",
                        attributes = attribs,
                        body = parse(_body, {}, true),
                        identifier = _ide
                    }
                end

                if tokens[1].value == "return" then
                    table.remove(tokens, 1)
                    if #tokens == 0 then
                        return {
                            type = "RET",
                            value = {
                                type = "NUL",
                                value = "null"
                            }
                        }
                    end

                    return {
                        type = "RET",
                        value = parse(tokens, {}, false)[1]
                    }
                end

                if tokens[1].value == "break" then
                    -- INFO: BREAK

                    table.remove(tokens, 1)
                    return {
                        type = "BRK"
                    }
                elseif tokens[1].value == "continue" then
                    -- INFO: CONTINUE

                    table.remove(tokens, 1)
                    return {
                        type = "CON"
                    }
                end
            end

            if tokens[1].type == "IDE" or tokens[1].type == "IDX" then
                if #tokens > 1 and tokens[2].type == "LBA" then
                    -- INFO: INDEX

                    local _ide = table.remove(tokens, 1)
                    table.remove(tokens, 1)

                    local _index = {}
                    local s_index = 0

                    if tokens[1].type ~= "RBA" then
                        while #tokens > 0 do
                            table.insert(_index, table.remove(tokens, 1))

                            if tokens[1].type == "LBA" then
                                s_index = s_index + 1
                            end

                            if tokens[1].type == "RBA" and s_index == 0 then
                                break
                            elseif tokens[1].type == "RBA" then
                                s_index = s_index - 1
                            end
                        end
                    end
                    if #tokens == 0 then
                        giveError("missing ']' to close '['")
                    end
                    table.remove(tokens, 1)

                    if #tokens > 0 and tokens[1].type == "LBA" then
                        table.insert(tokens, 1, {
                            type = "IDX",
                            identifier = _ide,
                            index = parse(_index, {}, false)[1]
                        })

                        return parse(tokens, {}, false)[1]
                    end

                    return {
                        type = "IDX",
                        identifier = _ide,
                        index = parse(_index, {}, false)[1]
                    }
                end
            end

            if tokens[1].type == "LBA" then
                -- INFO: ARRAY/DICTIONARY: LIST

                table.remove(tokens, 1)

                local array = {}

                if #tokens > 1 and tokens[1].type ~= "RBA" then
                    while #tokens > 0 do
                        if tokens[2].type == "COL" then
                            local _key = table.remove(tokens, 1)

                            table.remove(tokens, 1)
                            array[_key] = parse(tokens, {}, false)[1]
                        else
                            table.insert(array, parse(tokens, {}, false)[1])
                        end

                        if tokens[1].type == "COM" then
                            table.remove(tokens, 1)
                            goto continue
                        end
                        if tokens[1].type == "RBA" then
                            break
                        end
                        giveError("missing ']' to close '[' near '" .. getValue(tokens[1]) .. "'", tokens[1].line)

                        ::continue::
                    end
                end
                if #tokens == 0 then
                    giveError("missing ']' to close '['")
                end
                table.remove(tokens, 1)

                local new_array = {}
                for i, v in pairs(array) do
                    if tonumber(i) then
                        new_array[{
                            type = "NUM",
                            value = tostring(tonumber(i) - 1)
                        }] = v
                    else
                        new_array[i] = v
                    end
                end

                return {
                    type = "SET",
                    elements = new_array
                }
            end

            if #tokens > 1 and tokens[2].type == "EQL" then
                if #tokens > 2 then
                    if tokens[3].type ~= "EQL" then
                        giveError("attempt to define a " .. getType(tokens[1]), tokens[1].line)
                    end
                else
                    giveError("attempt to define a " .. getType(tokens[1]), tokens[1].line)
                end
            end

            if tokens[1].type == "RPA" then
                giveError("missing '(' to open ')' near '" .. getValue(tokens[2]) .. "'", tokens[1].line)
            end

            return table.remove(tokens, 1)
        end

        function parse(tokens, ast, rec)
            if #tokens == 0 then
                return {}
            end
            table.insert(ast, bool(tokens))

            if rec and #tokens > 0 then
                return parse(tokens, ast, true)
            end

            return ast
        end

        return parse(code, {}, true)
    end

    function split(code, starter_line)
        -- INFO: SPLITTER

        starter_line = starter_line or 1

        function Find_in_array(array, value)
            for i, v in pairs(array) do
                if value == "any thing" then
                    return i
                end
                if type(value) == "table" and type(v) == "table" then
                    for j, k in pairs(value) do
                        if k == "any thing" then
                            value[j] = v[j]
                        end
                    end
                end
                if v == value then
                    return i
                end
            end
        end

        function RemoveMagic(char)
            if char == "(" or char == ")" or char == "." or char == "[" or char == "^" or char == "$" or char == "%" then
                return "%%" .. char
            else
                return char
            end
        end

        local hex_chars = " 0123456789ABCDEF"
        local bin_chars = " 01"

        function CheckBase(value, base, chars)
            value = tostring(value)
            if string.sub(value, 2, 2) ~= base or string.sub(value, 1, 1) ~= "0" then
                return false
            end

            value = string.sub(value, 3, #value)
            for i = 1, #value do
                local char = string.sub(value, i, i)
                if not string.find(chars, RemoveMagic(string.upper(char))) then
                    return false
                else
                    if string.find(chars, RemoveMagic(string.upper(char))) == 1 then
                        return false
                    end
                end
            end

            return true
        end

        function IsBase(char, chars)
            if not string.find(chars, RemoveMagic(string.upper(char))) then
                return false
            else
                if string.find(chars, RemoveMagic(string.upper(char))) == 1 then
                    return false
                end
            end

            return true
        end

        local escape_sequences = {
            ["n"] = "\n",
            ["t"] = "\t",
            ["\\"] = "\\",
            ["'"] = "'",
            ['"'] = '"',
            ["r"] = "\r",
            ["b"] = "\b",
            ["f"] = "\f",
            ["a"] = "\a",
            ["v"] = "\v",
            ["0"] = "\0",
            ["27["] = "\27["
        }

        function isSlash(str)
            local nchar = string.sub(str.value, 2, 2)

            if find_index(escape_sequences, nchar) then
                return true
            end

            giveError("unexpected character sequence '\\" .. nchar .. "'", str.line)
        end

        function isAnsi(str, i)
            if string.sub(str, i + 1, i + 3) == "27[" then
                return true
            end

            return false
        end

        local code_chunks = {}

        local chunk = ""
        local open_string = ""

        local allowed_chars = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
        local string_index = 0
        local skip_index = 0

        for i = 1, #code do
            if skip_index >= i then
                goto continue
            end

            local char = string.sub(code, i, i)

            if open_string ~= "" and char == "\\" then
                if isAnsi(code, i) then
                    chunk = chunk .. "\27["

                    skip_index = i + 3

                    goto continue
                else
                    local nchar = string.sub(code, i + 1, i + 1)

                    skip_index = i + 1

                    chunk = chunk .. escape_sequences[nchar]

                    goto continue
                end
            end

            if char == '"' and open_string == "" then
                if chunk ~= "" then
                    table.insert(code_chunks, chunk)
                end
                chunk = ""

                string_index = i
                open_string = '"'
            elseif char == "'" and open_string == "" then
                if chunk ~= "" then
                    table.insert(code_chunks, chunk)
                end
                chunk = ""

                string_index = i
                open_string = "'"
            end

            if char == " " or not string.find(allowed_chars, RemoveMagic(char)) then
                if open_string ~= "" then
                    chunk = chunk .. char
                else
                    if not (char == "-" and tonumber(string.sub(code, i + 1, i + 1)) and not tonumber(string.sub(code, i - 1, i - 1))) then
                        if chunk ~= "" then
                            table.insert(code_chunks, chunk)
                        end
                        if char ~= " " then
                            table.insert(code_chunks, char)
                        end
                        chunk = ""
                    else
                        if chunk ~= "" then
                            table.insert(code_chunks, chunk)
                        end
                        chunk = "-"
                    end
                end
            else
                if string.find(allowed_chars, RemoveMagic(char)) == 1 then
                    if chunk ~= "" then
                        table.insert(code_chunks, chunk)
                    end
                    if char ~= " " then
                        table.insert(code_chunks, char)
                    end
                    chunk = ""

                    goto continue
                end
                if open_string ~= "" then
                    chunk = chunk .. char
                else
                    if tonumber(char) and not tonumber(string.sub(code, i + 1, i + 1)) then
                        chunk = chunk .. char
                        if string.sub(code, i + 1, i + 1) == "." and tonumber(string.sub(code, i + 2, i + 2)) then
                            chunk = chunk .. string.sub(code, i + 1, i + 1)
                            skip_index = i + 1
                        else
                            if tostring(chunk) == "0" then
                                if string.sub(code, i + 1, i + 1) ~= "x" and string.sub(code, i + 1, i + 1) ~= "b" then
                                    table.insert(code_chunks, chunk)
                                    chunk = ""
                                end
                            else
                                chunk = string.sub(tostring(chunk), 1, #tostring(chunk) - 1)
                                if (not CheckBase(chunk, "x", hex_chars)) and (not CheckBase(chunk, "b", bin_chars)) then
                                    table.insert(code_chunks, chunk .. char)
                                    chunk = ""
                                else
                                    if CheckBase(chunk, "b", bin_chars) then
                                        if not string.find(bin_chars, char) then
                                            table.insert(code_chunks, chunk)
                                            chunk = char
                                        else
                                            if string.find(bin_chars, char) == 1 then
                                                table.insert(code_chunks, chunk)
                                                chunk = char
                                            else
                                                chunk = chunk .. char
                                            end
                                        end
                                    else
                                        chunk = chunk .. char
                                    end
                                end
                            end
                        end
                    else
                        if string.sub(tostring(chunk), 1, 1) == "0" and string.sub(tostring(chunk), 2, 2) == "x" then
                            if IsBase(char, hex_chars) then
                                chunk = chunk .. char
                            else
                                table.insert(code_chunks, chunk)
                                chunk = char
                            end
                        elseif string.sub(tostring(chunk), 1, 1) == "0" and string.sub(tostring(chunk), 2, 2) == "b" then
                            if IsBase(char, bin_chars) then
                                chunk = chunk .. char
                            else
                                table.insert(code_chunks, chunk)
                                chunk = char
                            end
                        else
                            chunk = chunk .. char
                        end
                    end
                end
            end

            if char == '"' and open_string == '"' and string_index ~= i then
                if chunk ~= "" then
                    table.insert(code_chunks, chunk)
                end
                chunk = ""

                open_string = ""
            elseif char == "'" and open_string == "'" and string_index ~= i then
                if chunk ~= "" then
                    table.insert(code_chunks, chunk)
                end
                chunk = ""

                open_string = ""
            end

            ::continue::
        end

        if chunk ~= "" then
            table.insert(code_chunks, chunk)
        end

        local _line = starter_line
        local line_chunks = {}

        for i, v in pairs(code_chunks) do
            if v == "\n" then
                _line = _line + 1
            end

            table.insert(line_chunks, {
                line = _line,
                value = v
            })
        end

        if open_string ~= "" then
            giveError("missing '\"' to close '\"'", line_chunks[#line_chunks].line)
        end

        if find_inval(line_chunks, "#") then
            repeat
                local pos = find_inval(line_chunks, "#")
                local pline = line_chunks[pos].line

                if #line_chunks > pos and line_chunks[pos + 1].value == "*" then
                    local closed = false

                    repeat
                        local last = find_inval(line_chunks, "#", pos + 1)
                        if last then
                            closed = true
                        else
                            last = #line_chunks
                        end

                        for i = pos, last do
                            table.remove(line_chunks, pos)
                        end
                    until #line_chunks == 0 or closed

                    if not closed then
                        giveError("missing '*#' to close '#*'", pline)
                    end
                else
                    repeat
                        local last = find_inval(line_chunks, "\n") or #line_chunks

                        for i = pos, last do
                            table.remove(line_chunks, pos)
                        end
                    until (not find_inval(line_chunks, "#")) or (#line_chunks > find_inval(line_chunks, "#") and find_inval(line_chunks, "#") and line_chunks[find_inval(line_chunks, "#") + 1] ~= "*")
                end
            until not find_inval(line_chunks, "#")
        end

        local chunk_index = 0
        while not (chunk_index > #line_chunks) do
            chunk_index = chunk_index + 1
            if chunk_index > #line_chunks then
                break
            end
            if tonumber(line_chunks[chunk_index].value) and string.sub(line_chunks[chunk_index].value, 1, 2) ~= "0x" then
                line_chunks[chunk_index].value = tonumber(line_chunks[chunk_index].value)
            elseif string.sub(line_chunks[chunk_index].value, 1, 2) == "0b" then
                if #line_chunks[chunk_index].value > 2 then
                    local result = 0

                    for i = 3, #line_chunks[chunk_index].value do
                        local char = string.sub(line_chunks[chunk_index].value, i, i)

                        result = result + tonumber(char) * (i - 2)
                    end

                    line_chunks[chunk_index].value = result
                end

                giveError("attempt to give binary base to invalid number", line_chunks[chunk_index].line)
            elseif string.sub(line_chunks[chunk_index].value, 1, 2) == "0x" and #line_chunks[chunk_index].value == 2 then
                giveError("attempt to give hexadecimal base to invalid number", line_chunks[chunk_index].line)
            end
            if line_chunks[chunk_index].value == "" or line_chunks[chunk_index].value == " " or line_chunks[chunk_index].value == "\n" or line_chunks[chunk_index].value == " " then
                table.remove(line_chunks, chunk_index)
                chunk_index = chunk_index - 1
            end
        end

        return line_chunks
    end

    function EqualLists(list1, list2)
        for i, v in pairs(list1) do
            if list1[i] ~= list2[i] then
                return false
            end
        end
        return true
    end

    function Find_in_array(array, value)
        for i, v in pairs(array) do
            if value == "any thing" then
                return i
            end
            if type(value) == "table" and type(v) == "table" then
                for j, k in pairs(value) do
                    if k == "any thing" then
                        value[j] = v[j]
                    end
                end
                if EqualLists(v, value) then
                    return i
                end
            end
            if v == value then
                return i
            end
        end
    end

    function GetToken(_value)
        if _value == "+" then
            return {
                type = "ADD"
            }
        elseif _value == "-" then
            return {
                type = "SUB"
            }
        elseif _value == "*" then
            return {
                type = "MLT"
            }
        elseif _value == "/" then
            return {
                type = "DIV"
            }
        elseif _value == "|" then
            return {
                type = "BAR"
            }
        elseif _value == "&" then
            return {
                type = "AND"
            }
        elseif _value == "^" then
            return {
                type = "XOR"
            }
        elseif _value == "%" then
            return {
                type = "PRC"
            }
        elseif _value == "!" then
            return {
                type = "EXC"
            }
        elseif _value == "?" then
            return {
                type = "QST"
            }
        elseif _value == "(" then
            return {
                type = "LPA"
            }
        elseif _value == ")" then
            return {
                type = "RPA"
            }
        elseif _value == "[" then
            return {
                type = "LBA"
            }
        elseif _value == "]" then
            return {
                type = "RBA"
            }
        elseif _value == "<" then
            return {
                type = "INF"
            }
        elseif _value == ">" then
            return {
                type = "SUP"
            }
        elseif _value == "#" then
            return {
                type = "HSH"
            }
        elseif _value == "{" then
            return {
                type = "LBR"
            }
        elseif _value == "}" then
            return {
                type = "RBR"
            }
        elseif _value == "@" then
            return {
                type = "ATS"
            }
        elseif _value == "." then
            return {
                type = "DOT"
            }
        elseif _value == "," then
            return {
                type = "COM"
            }
        elseif _value == ":" then
            return {
                type = "COL"
            }
        elseif _value == ";" then
            return {
                type = "SCL"
            }
        elseif _value == "_" then
            return {
                type = "UND"
            }
        elseif _value == "=" then
            return {
                type = "EQL"
            }
        elseif _value == "$" then
            return {
                type = "DOL"
            }
        elseif tonumber(_value) or tostring(string.sub(_value, 1, 2)) == "0x" or tostring(string.sub(_value, 1, 2)) == "0b" then
            return {
                type = "NUM",
                value = tostring(_value)
            }
        elseif (string.sub(_value, 1, 1) == '"' and string.sub(_value, #_value, #_value) == '"') or
            (string.sub(_value, 1, 1) == "'" and string.sub(_value, #_value, #_value) == "'") then
            return {
                type = "STR",
                value = string.sub(_value, 2, #_value - 1)
            }
        elseif _value == "true" or _value == "false" then
            return {
                type = "BOL",
                value = _value
            }
        elseif _value == "null" or _value == nil or _value == "" or _value == "\n" or _value == " " then
            return {
                type = "NUL",
                value = "null"
            }
        else
            return {
                type = "IDE",
                value = _value
            }
        end
    end

    function lexer(code)
        -- INFO: LEXER
        local new_code = {}
        for i, v in pairs(code) do
            new_code[i] = GetToken(v.value)
            new_code[i].line = v.line
        end

        return new_code
    end
end)

function main(code, filename)
    new_line = true
    if code then
        local _s, _e = pcall(function()
            createTraceback(filename)
            interpreter(parser(lexer(split(code))))
        end)

        stack = {}

        if _e then
            if string.find(_e, "exit") then
                return "exit"
            elseif string.find(_e, "stack overflow") then
                print(getErrorLine(filename, latest_line, "stack overflow"))

                new_line = true
            end
        end
    end

    return new_line
end

function getFile(name)
    local file
    local _s, _e = pcall(function()
        file = io.open(name)
    end)

    if file then
        return file:read("*a")
    else
        print(getErrorLine("[LUA]", "?", "attempt to open file or directory '" .. name .. "' not found"))
        new_line = true
    end
end

local tagl = "LowScript 1.0  Copyright (C)  2024-2024 TN"

if arg[1] then
    if arg[1] == "--version" then
        print(tagl)

        return
    end

    main(getFile(arg[1]), arg[1])
else
    print(tagl)
    while true do
        io.write("> ")
        local ran = main(io.read("*l"), "terminal")

        if ran == "exit" then
            os.exit()
        end

        if not ran then
            print("")
        end
        print("")
    end
end
