note
	description	: "Main window for this application"
	author		: "Generated by the New Vision2 Application Wizard."
	date		: "Date: 2010/9/3 21:44:11"
	revision	: "1.0.0"

class
	MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

	INTERFACE_NAMES
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	default_create

feature {NONE} -- Initialization


	initialize
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}

				-- Create and add the menu bar.
			build_standard_menu_bar
			set_menu_bar (standard_menu_bar)

			build_main_container_default
			extend (main_container)

				-- Execute `request_close_window' when the user clicks
				-- on the cross in the title bar.
			close_request_actions.extend (agent request_about_quit)

				-- Set the title of the window
			set_title (Window_title)

				-- Set the initial size of the window
			set_size (Window_width, Window_height)

			disable_user_resize

		end

	is_in_default_state: BOOLEAN
			-- Is the window in its default state
			-- (as stated in `initialize')
		do
			Result := True
		end

feature --access

	--allows to set one cell value
	set_value_of_cell(row,col,value : INTEGER)
		require
			col >= 1 and col <= 9
			row >= 1 and row <= 9
			value >= 0 and value <= 9
		local
			current_cell : CELL_TEXT_FIELD
		do
			current_cell ?= l_table.item_at_position (col, row)
			if value = 0 then
				current_cell.set_text ("")
			else
				current_cell.set_text (value.out)
			end
		end

feature {NONE} -- Menu Implementation

	standard_menu_bar: EV_MENU_BAR
			-- Standard menu bar for this window.

	file_menu: EV_MENU
			-- "File" menu for this window (contains New, Open, Close, Exit...)

	help_menu: EV_MENU
			-- "Help" menu for this window (contains About...)

	build_standard_menu_bar
			-- Create and populate `standard_menu_bar'.
		require
		  menu_bar_not_yet_created: standard_menu_bar = Void
		do
				-- Create the menu bar.
			create standard_menu_bar

				-- Add the "File" menu
			build_file_menu
			standard_menu_bar.extend (file_menu)


				-- Add the "Help" menu
			build_help_menu
			standard_menu_bar.extend (help_menu)
		ensure
			menu_bar_created:
				standard_menu_bar /= Void and then
				not standard_menu_bar.is_empty
		end

	build_file_menu
			-- Create and populate `file_menu'.
		require
			file_menu_not_yet_created: file_menu = Void
		local
			menu_item : EV_MENU_ITEM
			separator_item : EV_MENU_SEPARATOR
		do
			create file_menu.make_with_text (Menu_file_item)

			create menu_item.make_with_text (Menu_file_new_item)
			menu_item.select_actions.extend (agent request_about_new) --controller for click in new
 			file_menu.extend (menu_item)    	-- New

			create menu_item.make_with_text (Menu_file_close_item)
		    file_menu.extend (menu_item)   		-- Close

			create separator_item.default_create
			file_menu.extend (separator_item) 	-- Separator

            create menu_item.make_with_text (Menu_file_save_item)
			file_menu.extend (menu_item)     	-- Save

			create menu_item.make_with_text (Menu_file_saveas_item)
			file_menu.extend (menu_item)       	-- Save All

			create separator_item.default_create
			file_menu.extend (separator_item) 	-- Separator

			create menu_item.make_with_text (Menu_file_open_item)
			file_menu.extend (menu_item)    	-- Open

			create separator_item.default_create
			file_menu.extend (separator_item)  	 --Separator

			create menu_item.make_with_text (Menu_file_exit_item)
			menu_item.select_actions.extend (agent request_about_quit)
			-- menu_item.select_actions.extend (agent request_close_window)
			file_menu.extend (menu_item)        --Close

		ensure
			file_menu_created: file_menu /= Void and then not file_menu.is_empty
		end

	build_help_menu
			-- Create and populate `help_menu'.
		require
			help_menu_not_yet_created: help_menu = Void
		local
			menu_item: EV_MENU_ITEM
			about: ABOUT_DIALOG
			separator_item : EV_MENU_SEPARATOR
		do
			create help_menu.make_with_text (Menu_help_item)
                                                 -- Help
            create menu_item.make_with_text (Menu_help_contents_item)
            help_menu.extend (menu_item)		 -- Contents and Index

            create separator_item.default_create
			help_menu.extend (separator_item)  	 -- Separator

			create menu_item.make_with_text (Menu_help_about_item)
			menu_item.select_actions.extend (agent request_about_dialog)
			help_menu.extend (menu_item)
		ensure
			help_menu_created: help_menu /= Void and then not help_menu.is_empty
		end


feature {NONE} -- ToolBar Implementation



feature {NONE} -- StatusBar Implementation

	standard_status_bar: EV_STATUS_BAR
			-- Standard status bar for this window


feature -- Implementation, Close event

	request_close_window
		do
				-- Destroy the window
			destroy;
				-- End the application
				--| TODO: Remove this line if you don't want the application
				--|       to end when the first window is closed..
			(create {EV_ENVIRONMENT}).application.destroy
		end


feature -- Implementation, Open About Quit to ask if a user really want to quit the application

	request_about_quit
		local
			about_window: ABOUT_QUIT
		do
			create about_window
			about_window.add_close_action(Current)
			about_window.show
		end

feature -- Implementation, Open About

	request_about_dialog
		local
			about_window: ABOUT_DIALOG
		do
			create about_window
			about_window.show
		end

feature {NONE} -- Implementation

	main_container : EV_VERTICAL_BOX
			-- Main container (contains all widgets displayed in this window)

	l_table : EV_TABLE

	build_sudoku_table
		local
			current_text_field : CELL_TEXT_FIELD
			row,col: INTEGER
			font : EV_FONT
			a_color,b_color: EV_COLOR
		do
			main_container.enable_sensitive -- the container is unlocked
			create font.default_create
			font.set_weight( (create {EV_FONT_CONSTANTS}).weight_bold)
			create a_color.make_with_rgb(0.6,0.6,0.6)
			create b_color.make_with_rgb (0.9,0.9,0.9)

			from
				row:= 1
			until
				row > 9
			loop
				from
					col := 1
				until
					col > 9
				loop
					create current_text_field.default_create
					current_text_field.add_control_caracter
					current_text_field.set_capacity (1)
					current_text_field.align_text_center
					current_text_field.set_minimum_width_in_characters (1)

					if ((((row+2)//3)+((col+2)//3))\\2)= 0  then
						current_text_field.set_background_color (b_color)
					else
						current_text_field.set_background_color (a_color)
					end
					-- gives the current cell its position in the board
					current_text_field.set_position (row, col)

					l_table.put_at_position (current_text_field, col,row,1,1)
					col := col +1
				end
				row := row +1
			end
		end


	build_main_container_default
			-- Create and populate `default_main_container'.
		require
			main_container_not_yet_created: main_container = Void
		do
			create l_table
			l_table.resize (9,9)
			l_table.set_border_width (0)
			create main_container
			build_sudoku_table
			main_container.extend (l_table)
		ensure
			main_container_created: main_container /= Void
		end

		request_about_new
		do
			controller.reset_game
		end


feature {ANY} -- setters
		set_controller(ctller:SUDOKU_CONTROLLER)
	require
		ctller /= Void
	do
		controller:=ctller
		set_controller_for_each_cell
	end

feature {NONE} -- setter private

	-- Set the controller in each cell
	set_controller_for_each_cell
	require
		controller /= Void
	local
		current_cell : CELL_TEXT_FIELD
		row, col : INTEGER
	do
		from
			row := 1
		until
			row > 9
		loop
			from
				col := 1
			until
				col > 9
			loop
				current_cell ?= l_table.item_at_position (col, row)
				current_cell.set_controller (controller)
				col := col + 1
			end
			row := row + 1
		end
	end




feature {NONE} -- Implementation / Constants

	Window_title: STRING = "Eiffel Sudoku"
			-- Title of the window.

	Window_width: INTEGER = 280
			-- Initial width for this window.

	Window_height: INTEGER = 280
			-- Initial height for this window.


	mine_icon: EV_PIXMAP

	controller: SUDOKU_CONTROLLER

feature {ANY}



end
