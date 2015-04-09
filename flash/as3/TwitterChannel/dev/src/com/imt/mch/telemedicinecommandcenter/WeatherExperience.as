﻿package com.imt.mch.TeleMedicineCommandCenter{			import com.bedrock.framework.plugin.util.TimeUtil;	import com.bedrock.framework.plugin.view.IView;	import com.bedrock.framework.plugin.view.MovieClipView;	import com.bedrock.framework.plugin.view.ViewEvent;	import com.dj.googleweather.GoogleWeatherService;	import com.dj.googleweather.data.ForecastCondition;	import com.dj.googleweather.data.Weather;	import com.dj.googleweather.event.GoogleWeatherServiceFaultEvent;	import com.dj.googleweather.event.GoogleWeatherServiceResultEvent;	import com.greensock.TimelineMax;	import com.greensock.TweenMax;	import com.greensock.events.LoaderEvent;	import com.greensock.loading.ImageLoader;	import com.imt.framework.plugin.weather.component.WeatherComponent;	import com.imt.framework.icon.WeatherIcon;	import com.imt.mch.TeleMedicineCommandCenter.data.CommandCenterData;		import flash.display.MovieClip;	import flash.events.Event;	import flash.net.URLRequest;	import flash.text.TextField;	import flash.ui.Mouse;		import hype.framework.rhythm.SimpleRhythm;		import net.charlesclements.gadgets.text.StatusField;	import net.charlesclements.gadgets.time.TimeGadget;		import settings.Settings;
			public class WeatherExperience extends MovieClipView implements IView	{						public var timeDisplay:TextField;		public var ampm:TextField;		private var _rhythm:SimpleRhythm;		private var service:GoogleWeatherService;		public var weather:MovieClip;		private var _day0:WeatherComponent;		private var _day1:WeatherComponent;		private var _day2:WeatherComponent;		private var _day3:WeatherComponent;		private var _days:Array;		private var _currentForecast:Array;		private var _targetForecast:Array;		private var _timeline:TimelineMax;		private var _timer:TweenMax;				private var _status:StatusField;						public function WeatherExperience()		{			super();						initialize();		}						private function showTime($e:Object):void		{						timeDisplay.text = "Local: " + TimeGadget.getFormattedTime( { ampm:false } );			ampm.text = TimeGadget.getAmPm();					}						// Do initialize.		public function initialize($data:Object=null):void		{						// Set days.			_day0 = weather.day0;			_day1 = weather.day1;			_day2 = weather.day2;			_day3 = weather.day3;						// Store days in Array.			_days = [ _day0, _day1, _day2, _day3 ];						// Hide all.			TweenMax.allTo( _days, 0, { autoAlpha:0 } );						// Setup Google service.			service = new GoogleWeatherService();			service.addEventListener(GoogleWeatherServiceResultEvent.RESULT,onResult);			service.addEventListener(GoogleWeatherServiceFaultEvent.FAULT,onFault);						// Check weather.			_timer = TweenMax.to( {}, Settings.WEATHER_UPDATE_INTERVAL, { repeat:0, onComplete:getWeather } ); 			_timer.pause();			getWeather();									_rhythm = new SimpleRhythm( showTime );			_rhythm.start();						Mouse.hide();					}						// Do intro.		public function intro($data:Object=null):void		{						if( Settings.DEBUG ) trace("intro");						TweenMax.allTo( _days, 0.7, { autoAlpha:1 }, 0.5, introDone );					}				private function introDone($e:ViewEvent=null):void		{						if( Settings.DEBUG ) trace("introDone")						// Restart timer.			_timer.restart();						introComplete();					}						/**		 * Result handler for the service call		 */ 		private function onResult(e:GoogleWeatherServiceResultEvent):void		{						if( Settings.DEBUG ) trace("onResult")						_targetForecast = e.data.forecastConditions;						// Call the outro to prep the components to be refreshed.			outro();					}						private function change():WeatherExperience		{						if( Settings.DEBUG ) trace("change")									// Loop thru forecast.			for(var i:uint = 0; i < _targetForecast.length; i++)			{								var f:ForecastCondition = _targetForecast[i] as ForecastCondition;				var d:WeatherComponent = _days[ i ];								// Set text.				d.dayOfWeek = ( i > 0 ) ? f.dayOfWeek : "Today";				d.condition = "High:" + f.high + "\n" + "Low:" + f.low + "\n" + f.condition;								// Add graphic icon.				addWeatherIcon( d, f.condition )//.update();							}						return this;					}						private function addWeatherIcon( $component:WeatherComponent, $condition:String ):WeatherComponent		{						// Create icon var.			var icon:WeatherIcon;						// 			switch( $condition.toUpperCase() )			{								case "PARTLY SUNNY":					icon = ( new sun_2 ) as WeatherIcon;					break;								case "SCATTERED THUNDERSTORMS":					icon = ( new cloud_3 ) as WeatherIcon;					break;								case "SHOWERS":					icon = ( new cloud_8 ) as WeatherIcon;					break;								case "SCATTERED SHOWERS":					icon = ( new cloud_8 ) as WeatherIcon;					break;								case "RAIN AND SNOW":					icon = ( new cloud_9 ) as WeatherIcon;					break;								case "OVERCAST":					icon = ( new cloud_7 ) as WeatherIcon;					break;								case "LIGHT SNOW":					icon = ( new cloud_5 ) as WeatherIcon;					break;								case "FREEZING DRIZZLE":					icon = ( new cloud_9 ) as WeatherIcon;					break;								case "CHANCE OF RAIN":					icon = ( new sun_2 ) as WeatherIcon;					break;								case "SUNNY":					icon = ( new sun_1 ) as WeatherIcon;					break;								case "CLEAR":					icon = ( new sun_1 ) as WeatherIcon;					break;								case "MOSTLY SUNNY":					icon = ( new sun_2 ) as WeatherIcon;					break;								case "PARTLY CLOUDY":					icon = ( new sun_2 ) as WeatherIcon;					break;								case "MOSTLY CLOUDY":					icon = ( new cloud_6 ) as WeatherIcon;					break;								case "CHANCE OF STORM":					icon = ( new cloud_3 ) as WeatherIcon;					break;								case "SLEET":					icon = ( new snow_1 ) as WeatherIcon;					break;								case "SNOW":					icon = ( new cloud_5 ) as WeatherIcon;					break;								case "ICY":					icon = ( new snow_1 ) as WeatherIcon;					break;								case "DUST":					icon = ( new cloud_1 ) as WeatherIcon;					break;								case "FOG":					icon = ( new fog_1 ) as WeatherIcon;					break;								case "SMOKE":					icon = ( new fog_1 ) as WeatherIcon;					break;								case "HAZE":					icon = ( new fog_1 ) as WeatherIcon;					break;								case "FLURRIES":					icon = ( new snow_1 ) as WeatherIcon;					break;								case "LIGHT RAIN":					icon = ( new cloud_2 ) as WeatherIcon;					break;								case "SNOW SHOWERS":					icon = ( new cloud_9 ) as WeatherIcon;					break;								case "ICE/SNOW":					icon = ( new snow_1 ) as WeatherIcon;					break;								default:					icon = ( new sun_2 ) as WeatherIcon;							}						// Add icon.			icon.x = $component.width / 2;			icon.scaleX = icon.scaleY = 2.45;			icon.y = 25;			//icon.cacheAsBitmap = true;						$component.icon = icon;						return $component;					}								/**		 * Error handler for the service call		 */ 		private function onFault(e:GoogleWeatherServiceFaultEvent):void		{						trace(e.errorMessage);					}						private function getWeather():void		{						if( Settings.DEBUG ) trace("");			if( Settings.DEBUG ) trace("getWeather");						/**			 * The base URL:			 * http://www.google.com/ig/api?			 * This is the base URL which can be extended with the following parameters:			 * 			 * The Weather parameter:			 * weather=location			 * Where location can be either a zip code (weather=24060); city name, state (weather=woodland,PA); city name, country (weather=london,england); or possibly others. Try it out and see what response you get back to test your location.			 * 			 * The language parameter:			 * hl=ISO 639-1 Language Code			 * Please note that changing the language parameter can also alter the units of the data retreived. e.g. degrees will be in celcius			 * instead of fahrenheit, wind speed will be in kph instead of mph.			 *				 * 			 * For example, to get the weather for Paris, France in French, one would use the following URL:			 * http://www.google.com/ig/api?weather=paris,france&hl=fr			 * 			 * The Google Weather API is not an official public Google API so use it wisely.			 * 			 * This is unofficial documentation retreived from http://blog.emerick.org/2008/05/07/google-weather-api-feed-documentation/			 */						//we need to use a proxy in order to avoid flash player security issues			//var url:String = Settings.PROXY_URL + GoogleWeatherService.BASE_QUERY_URL + "weather=" + city.text + "," + country.text + "&hl=";			var url:String = Settings.PROXY_URL + GoogleWeatherService.BASE_QUERY_URL + "weather=" + CommandCenterData.ZIPCODE + "," + CommandCenterData.COUNTRY + "&hl=";			service.getWeather(url); //get the weather from the service					}						// Do outro.		public function outro($data:Object=null):void		{						if( Settings.DEBUG ) trace("outro");						TweenMax.allTo( _days, 0.5, { autoAlpha:0 }, 0.4, outroDone );					}						private function outroDone($e:ViewEvent=null):void		{						if( Settings.DEBUG ) trace("outroDone")						change().intro();					}						public function clear():void		{		}					}}