# Tablegrid Rails Gem

## What is this?
* Generic helper for creating table-grid views. 
* The original idea comes from http://coryodaniel.com/index.php/2011/02/16/hamlburgerhelper-sets-the-table-easily-create-and-display-standard-tables-in-rails/ or http://dzone.com/snippets/hamlburger-helper-easily

## Integration in your Rails project: 
* In Gemfile: `gem 'tablegrid', :git => 'https://github.com/rostchri/tablegrid.git'`
* In application.js: `//= require tablegrid`
* In application.css: `*= require tablegrid`

## Requirements:
* Haml

## Example:
* Assuming we have a model named game with some attributes (id, homecompetitor, guestcompetitor, result, created_at, updated_at) and we want to build a simple html-table
* Content of games_helper.rb:

		module GamesHelper
		
			# at first define the colums/attributes which will can be part of the table
			def game_cols
				cols  = [:id]
				cols += [:homecompetitor,:guestcompetitor]
				cols += [:result]
				cols += [:created_at,:updated_at]
			end
  
			# the visibility of some attributes can be limited
		  def games_col_visible
		    {:col_visible   => ->(col) { 
					# users with role :masteradmin or :admin see all columns defined in game_cols, 
					# other users will never see id, created_at, updated_at - columns
					role?(:masteradmin,:admin) ? true : ![:id,:created_at,:updated_at].include?(col) 
		    }}
		  end
  
			# define the column-format. homecompetitor, guestcompetitor and result are more complex columns than id, 
			# created_at, and update_at and need to be rendered as partials
		  def games_cell_format
		    {:cell_format => {
		       :homecompetitor  => ->(o,v,i) { render(:partial => "competitors/competitor",  
                                                  :object => o.homecompetitor)) unless v.nil?},
		       :guestcompetitor => ->(o,v,i) { render(:partial => "competitors/competitor",  
                                                  :object => v)) unless v.nil?},
		       :result          => ->(o,v,i) { render :partial => "result/result", 
                                                  :object => v },
		      }
		    }
		  end
  
			# define games_grid-function which is used to render the actual table for a 
			# collection of game-objects using the table_grid-function
		  def games_grid(objects,paginator=nil)
		    options = { :row_layout  => game_cols,
		                :paginator   => paginator,
		                :format_date => lambda{|datetime| l datetime, :format => :short}, # use a special date/time format
		                :clickable_path => ->(obj)  {resource_path(obj) if permitted_to?(:show, obj)},
		                :edit_action    => ->(obj)  {link_to twitter_image('icon-pencil'), 
                                                         edit_game_path(obj) if permitted_to? :edit},
		                :destroy_action => ->(obj)  {button_to('', game_path(obj), :method => :delete, :class=>:delete, 
                                                 :confirm => t("Game.delete", :name => obj.name)) if permitted_to? :destroy},
		              }.merge(games_col_visible).merge(games_cell_format)
		    table_grid(objects, options)
		  end
  
  		# define game_grid-function which is used to render the actual table 
			# for a single game-object using the table_grid-function in vertical-layout
		  def game_grid(object)
		    options = {
		               :row_layout    => game_cols,
		               :vertical      => true, 
		               :caption       => t("#{resource_class}.show", :title => object.name) ,
		               :format_date   => ->(date) {l date, :format => :short_with_time},
		              }.merge(games_col_visible).merge(games_cell_format)
		    table_grid([object],options)
		  end
		end
* Use the above helper in the index-action:
	Assuming that the Game-Controller is based on InheritedResources (collection = games-objects) and that kaminari is used for pagination.
	content of index.html.haml: `= games_grid(collection,paginate(collection))`
* Use the above helper in the show-action:
	Assuming that the Game-Controller is based on InheritedResources (resource = game-object)
	Content of show.html.haml: `= game_grid(resource)`