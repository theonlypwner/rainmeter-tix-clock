-- Public functions (Rainmeter 3.3 hooks)
function Initialize()
	updateAll(true)
end

function Update()
	updateAll()
end

-- Choose N flags from M bits.
-- Adapted from http://stackoverflow.com/a/3724708
-- Lua 5.1 doesn't support bitwise...
function chooseBits(N, M)
	local a = {}
	local v = true
	if M < N*2 then
		v = nil
		N = M-N
	end
	for i = M-N, M-1 do
		local f = 0
		if i then
			f = math.random(0, i)
		end
		if a[f] then
			f = i
		end
		a[f] = true
	end
	return a, v
end

-- Update a section of meters
function updateSection(prefix, vCur, vMax, col)
	local f, v = chooseBits(vCur, vMax)
	for i=0, vMax-1 do
		if f[i] == v then
			SKIN:Bang('!SetOption', prefix..i, 'SolidColor', col)
		else
			SKIN:Bang('!SetOption', prefix..i, 'SolidColor', '#COL0#')
		end
	end
end

-- Update all sections
function updateAll(forceHM)
	local now = os.date("*t")
	local h = now.hour
	local m = now.min
	local s = now.sec
	if (s % 2) == 0 or forceHM then
		updateSection('MeterH0', math.floor(h / 10), 3, '#COL1#')
		updateSection('MeterH1',       h % 10      , 9, '#COL2#')
		updateSection('MeterM0', math.floor(m / 10), 6, '#COL3#')
		updateSection('MeterM1',       m % 10      , 9, '#COL1#')
	end
	updateSection('MeterS0', math.floor(s / 10), 6, '#COL2#')
	updateSection('MeterS1',       s % 10      , 9, '#COL3#')
end
