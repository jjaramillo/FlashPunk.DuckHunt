package co.FlashPunk.DuckHunt.Stages
{
	import co.FlashPunk.DuckHunt.Entities.Crosshair;
	import co.FlashPunk.DuckHunt.Entities.Dog;
	import co.FlashPunk.DuckHunt.Entities.Duck;
	import co.FlashPunk.DuckHunt.Util.Splash;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	public class MainStage extends World
	{
		//[Embed(source = 'assets/sounds/Round_Introduction.mp3')]
		//private const ROUND_START_SOUND:Class;
		[Embed(source = 'assets/sprites/background.png')]	
		private const BACKGROUND:Class;
		[Embed(source = 'assets/sprites/sky.png')]
		private const SKY:Class;
		
		private var background:Image = null;
		private var sky:Image = null;
		private var splash:Splash = new Splash();
		
		//private var RoundIntroduction:Sfx = new Sfx(ROUND_START_SOUND);
		
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
			sky = new Image(SKY);
			background.scale = this.Scale;
			sky.scale = this.Scale;
			
			addGraphic(sky, 2);
			addGraphic(background, 0);
			add(new Dog( 'walk' ))
		}
		
		public function startGame():void		
		{
			add(new Crosshair());
			add(new Duck());
		}
		
		public function addDuck():void
		{
			add(new Duck());
		}
		
		public function showDogWithDuck(x:Number, y:Number):void
		{
			var dog:Dog = new Dog( 'got_one' );
			dog.layer = 1;
			dog.x = x;
			dog.y = y - Dog.SPRITEHEIGHT;
			add(dog);
		}
		
		
	}
}