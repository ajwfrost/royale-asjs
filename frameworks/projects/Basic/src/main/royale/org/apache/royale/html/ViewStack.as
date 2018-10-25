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
package org.apache.royale.html
{
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.ValueEvent;
    
    /**
     *  Indicates that the selected/visible child container has changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    [Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  The ViewStack class implements a special container for other
     *  containers, where each of the child containers are effectively
     *  stacked on top of each other; only a single child container is
     *  visible at any one time. All child containers have the same position
     *  and size.
     * 
     *  A ViewStack container does not provide a user interface for selecting
     *  which child container is currently visible. Instead, you set its
     *  <code>selectedIndex</code> or <code>selectedChild</code> property
     *  in ActionScript in response to some user action.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */    
	public class ViewStack extends Container
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function ViewStack()
		{
			super();
            this.addEventListener("childrenAdded", onAddedChild);
		}
        
		/**
		 * @private
		 */
        private function onAddedChild(valueEvent : ValueEvent) : void
        {
            trace("Added child");
            trace(valueEvent.value);
            var element : IUIBase = valueEvent.value as IUIBase;
            if (element) element.visible = false;
            else throw new Error("Adding an invalid child to a ViewStack: it must implement IUIBase ");
        }
        
		/**
		 * @private
		 */
        private var _selectedIndex : int = -1;
        
        /**
         *  The zero-based index of the currently visible child container.
         *  Initially set to -1 by default; set this to switch to one
         *  of the children.
         *  When the selected index is changed, a <code>change</code> event
         *  is triggered.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get selectedIndex() : int
        {
            return _selectedIndex;
        }
        
		/**
		 * @private
		 */
        public function set selectedIndex(value : int) : void
        {
            // change the visibility if this is a valid value
            if (value < 0 || value >= numElements) return;
            if (_selectedIndex >= 0)
            {
                (getElementAt(_selectedIndex) as IUIBase).visible = false;
            }
            _selectedIndex = value;
            (getElementAt(_selectedIndex) as IUIBase).visible = true;
            dispatchEvent("change");
        }
        
        /**
         *  The currently visible child container. If there is no element
         *  selected, this will return null (i.e. <selectedIndex> is -1).
         *  When the selected child container is changed, a <code>change</code>
         *  event is triggered.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get selectedChild() : IChild
        {
            if (_selectedIndex < 0) return null;
            return getElementAt(_selectedIndex);
        }
        
		/**
		 * @private
		 */
        public function set selectedChild(value : IChild) : void
        {
            var idx : int = getElementIndex(value);
            if (idx >= 0)
            {
                // change by index (results in the setter -> raises the event)
                selectedIndex = idx;
            }
        }
        
        /**
         * Retrieves one of the child containers via its index.
         */
        public function getItemAt(idx : int) : IChild
        {
            if (id < 0 || idx >= numElements) return null;
            return getElementAt(idx);
        }
        
	}
}
