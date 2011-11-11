package co.FlashPunk.DuckHunt.Entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	public class Duck extends Entity
	{
		public function Duck(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
			super(x, y, graphic, mask);
		}
	}
}