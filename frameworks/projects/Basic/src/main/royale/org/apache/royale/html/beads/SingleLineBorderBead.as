////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.html.beads
{
    COMPILE::SWF
    {
	import flash.display.Graphics;
	import org.apache.royale.utils.CSSBorderUtils;
    }
    COMPILE::JS
    {
    import org.apache.royale.core.HTMLElementWrapper;
    }

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IStatesObject;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IBorderBead;

    /**
     *  The SingleLineBorderBead class draws a single line solid border.
     *  The color and thickness can be specified in CSS.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class SingleLineBorderBead implements IBead, IBorderBead, IGraphicsDrawing
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function SingleLineBorderBead()
		{
		}
		
		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            IEventDispatcher(value).addEventListener("heightChanged", changeHandler);
            IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(value).addEventListener("sizeChanged", changeHandler);
			IEventDispatcher(value).addEventListener("initComplete", changeHandler);
			IEventDispatcher(value).addEventListener("layoutComplete", changeHandler);
			var ilc:ILayoutChild = value as ILayoutChild;
			if (ilc)
			{
				if (!isNaN(ilc.explicitWidth) && !isNaN(ilc.explicitHeight))
				{
					changeHandler(null);
				}
			}
		}
        
        private var _borderStyle:String = "solid";
        
        /**
         *  The CSS style for the border (solid/dashed/hidden/etc)
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get borderStyle():String
        {
            return _borderStyle;
        }
        
        /**
         *  @private
         */
        public function set borderStyle(value:String):void
        {
            _borderStyle = value;
            COMPILE::SWF
            {
                ValuesManager.valuesImpl.setValue(_strand as UIBase, "border-style", value);
            }
            if( _strand )
                changeHandler(null);
        }

        private var _borderRadius:Number = 0.0;
        
        /**
         *  The border radius for corner curves
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get borderRadius():Number
        {
            return _borderRadius;
        }
        
        /**
         *  @private
         */
        public function set borderRadius(value:Number):void
        {
            _borderRadius = value;
            COMPILE::SWF
            {
                ValuesManager.valuesImpl.setValue(_strand as UIBase, "border-radius", value);
            }
            if( _strand )
                changeHandler(null);
        }

        private var _borderColor:uint = 0;
        
        /**
         *  The color of the border
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get borderColor():uint
        {
            return _borderColor;
        }
        
        /**
         *  @private
         */
        public function set borderColor(value:uint):void
        {
            _borderColor = value;
            COMPILE::SWF
            {
                ValuesManager.valuesImpl.setValue(_strand as UIBase, "border-color", value);
            }
            if( _strand )
                changeHandler(null);
        }

        private var _borderWidth:Number = 1.0;
        
        /**
         *  The width/thickness of the border line
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get borderWidth():Number
        {
            return _borderWidth;
        }
        
        /**
         *  @private
         */
        public function set borderWidth(value:Number):void
        {
            _borderWidth = value;
            COMPILE::SWF
            {
                ValuesManager.valuesImpl.setValue(_strand as UIBase, "border-width", value);
            }
            if( _strand )
                changeHandler(null);
        }

		protected function changeHandler(event:Event):void
		{
            COMPILE::SWF
            {
            var host:UIBase = UIBase(_strand);
            var g:Graphics = host.graphics;
            var w:Number = host.width;
            var h:Number = host.height;
            var state:String;
            if (host is IStatesObject)
                state = IStatesObject(host).currentState;
			
			var gd:IGraphicsDrawing = _strand.getBeadByType(IGraphicsDrawing) as IGraphicsDrawing;
			if( this == gd ) g.clear();
            
            CSSBorderUtils.draw(g, w, h, host, state, false, false);
            }
            COMPILE::JS
            {
                var htmlWrapper : HTMLElementWrapper = this._strand as HTMLElementWrapper;
                htmlWrapper.element.style["border-style"] = this._borderStyle;
                htmlWrapper.element.style["border-color"] = "#" + this._borderColor.toString(16);
                htmlWrapper.element.style["border-radius"] = this._borderRadius + "px";
                htmlWrapper.element.style["border-width"] = this._borderWidth + "px";
            }
		}
	}
}
