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
* Assuming we have a model named game with some attributes and we want to build a simple table
* Content of games_helper.rb:
		module GamesHelper
    
		  def game_cols
		    cols  = [:id]
		    cols += [:start_at,:parent_and_name] unless parent? || controller?(:leaguecompetitions) || (action?(:filter) && scope?(:by_competitions))
		    cols += [:name] if parent? || controller?(:leaguecompetitions) || (action?(:filter) && scope?(:by_competitions))
		    cols += [:homecompetitor,:guestcompetitor]
		    cols += [:advance,:gameset]  
		    cols += [:created_at,:updated_at]
		  end
  
		  def games_col_visible
		    {:col_visible   => ->(col) { 
		      role?(:guest,:admin) && [:start_at,:parent_and_name,:parent,:name,:hometeam,:homecompetitor,:guestcompetitor,:guestteam,:advance,:gameset,:winner].include?(col)
		    }}
		  end
  
		  def games_cell_format
		    {:cell_format => {
		                        :parent_and_name => ->(o,v,i) { render(:partial => "competitions/competition_with_parent", :object => o.competition) + (o.name.nil? ? "" : "/ #{o.name}") },
		                        :parent          => ->(o,v,i) { render :partial => "competitions/competition", :object => o.competition.parent },
		                        :hometeam        => ->(o,v,i) { render :partial => "teams/team",  :object => o.competition.homecompetitor},
		                        :homecompetitor  => ->(o,v,i) { ((o.homeassignment.winner ? twitter_image("icon-thumbs-up") : twitter_image("icon-thumbs-down"))  +  render(:partial => "competitors/competitor",  :object => o.homecompetitor)) unless o.homecompetitor.nil?},
		                        :guestcompetitor => ->(o,v,i) { ((o.guestassignment.winner ? twitter_image("icon-thumbs-up") : twitter_image("icon-thumbs-down")) +  render(:partial => "competitors/competitor",  :object => o.guestcompetitor)) unless o.guestcompetitor.nil?},
		                        :winner          => ->(o,v,i) { render :partial => "competitors/competitor",  :object => o.winnercompetitor unless o.winnercompetitor.nil?},
		                        :guestteam       => ->(o,v,i) { render :partial => "teams/team",  :object => o.competition.guestcompetitor},
		                        :advance         => ->(o,v,i) { render :partial => "games/advance", :locals => {:handicaps=>[o.homeassignment.handicap,o.guestassignment.handicap], :advance => o.advance}},
		                        :gameset         => ->(o,v,i) { render :partial => "games/gameset", :collection => o.sets },
		                        }
		      }
		  end
  
  
		  def games_grid(objects,paginator=nil)
		    options = { :row_layout  => game_cols,
		                :paginator   => paginator,
		                :id          => params[:by_players].nil? && params[:by_teams].nil? ? "games_index" : "games_filter",
		                :format_date => lambda{|datetime| l datetime, :format => :short},
		                :clickable_path => ->(obj)  {resource_path(obj) if permitted_to?(:show, obj)},
		                :edit_action    => ->(obj)  {link_to twitter_image('icon-pencil'), edit_game_path(obj) if permitted_to? :edit},
		                :destroy_action => ->(obj)  {button_to('', game_path(obj), :method => :delete, :class=>:delete, :confirm => t("Game.delete", :name => obj.name)) if permitted_to? :destroy},
		              }.merge(games_col_visible).merge(games_cell_format)
		    table_grid(objects, options)
		  end
  
  
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

 