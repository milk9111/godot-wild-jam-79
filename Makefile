web:
	Godot_v4.4-stable_win64.exe --headless --export-release Web ./_web/index.html
	butler push _web milk9111/unpaid-internship:web