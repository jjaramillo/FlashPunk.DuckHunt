package co.FlashPunk.DuckHunt.Stages
{
	import co.FlashPunk.DuckHunt.Entities.Crosshair;
	import co.FlashPunk.DuckHunt.Entities.Dog;
	import co.FlashPunk.DuckHunt.Entities.Duck;
	import co.FlashPunk.DuckHunt.Entities.Sky;
	import co.FlashPunk.DuckHunt.Util.Splash;
	
	import flash.utils.setTimeout;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	public class MainStage extends World
	{		
		[Embed(source = 'assets/sprites/background.png')]	
		private const BACKGROUND:Class;
		
		private var background:Image = null;
		public var sky:Sky = new Sky();
		private var splash:Splash = new Splash();
		
		
		private var DucksInScreen:Number = 0;
		private var DucksHit:Number = 0;
		private var Scale:Number = 3;
		
		public function MainStage()
		{	
			add(splash);
			splash.start(startStage);
		}
		
		public function startStage():void
		{
			this.remove(splash);
			background = new Image(BACKGROUND);			
			background.scale = this.Scale;
			
			add(sky);
			addGraphic(background, 0);
			add(new Dog( 'walk' ))
			
		}
		
		public function startGame():void		
		{
			add(new Crosshair());
			DucksHit = 0;
			DucksInScreen++;
			add(new Duck());
		}
		
		public function addDuck():void
		{
			DucksInScreen++;
			add(new Duck());
		}
		
		public function showDogWithDuck(x:Number, y:Number):void
		{
			setTimeout(
				function():void{
					var dog:Dog = new Dog( 'got_one' );
					dog.layer = 1;
					dog.x = x - Duck.SPRITEWIDTH;
					dog.y = y - Dog.SPRITEHEIGHT;
					add(dog);
					dog.GotIt.play();
				}, 1000);
			
		}
		
		public function TryToShowDog(x:Number=0, y:Number=0, success:Boolean = false):void
		{
			DucksInScreen--;
			if(success)
			{				
				DucksHit++;
			}
			if(DucksInScreen == 0)
			{
				switch (DucksHit)
				{
					case 0:
						/*
						 * All of the ducks got away.
						 */
						setTimeout(
							function():void{
								sky.changeSky( 'blue' );
								var dog:Dog = new Dog( 'laugh' );
								dog.layer = 1;
								dog.x = x - Duck.SPRITEWIDTH;
								dog.y = y - Dog.SPRITEHEIGHT;
								add(dog);
								dog.GotAway.play();
							}, 1000);
						break;
					case 1:
						/*
						 * One Duck got hit
						 */
						setTimeout(
							function():void{
								var dog:Dog = new Dog( 'got_one' );
								dog.layer = 1;
								dog.x = x - Duck.SPRITEWIDTH;
								dog.y = y - Dog.SPRITEHEIGHT;
								add(dog);
								dog.GotIt.play();
							}, 1000);
						break;
					case 2:
						/*
						 * Both of the ducks got hit
						 */
						setTimeout(
							function():void{
								var dog:Dog = new Dog( 'got_both' );
								dog.layer = 1;
								dog.x = x - Duck.SPRITEWIDTH;
								dog.y = y - Dog.SPRITEHEIGHT;
								add(dog);
								dog.GotIt.play();
							}, 1000);
						break;
				}
				DucksHit = 0;
				
			}
		}	
	}
}