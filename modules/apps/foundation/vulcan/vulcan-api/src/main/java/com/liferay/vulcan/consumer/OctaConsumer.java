/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.vulcan.consumer;

import java.util.Objects;

/**
 * Defines a {@code java.util.function.Consumer} that takes eight input
 * parameters. This consumer, like all consumers, doesn't return a result.
 *
 * <p>
 * This interface can be implemented with a lambda function.
 * </p>
 *
 * @author Alejandro Hernández
 */
@FunctionalInterface
public interface OctaConsumer<A, B, C, D, E, F, G, H> {

	/**
	 * Operates with eight parameters and returns {@code void}. This function
	 * can be implemented explicitly or with a lambda.
	 *
	 * @param a the first function argument
	 * @param b the second function argument
	 * @param c the third function argument
	 * @param d the fourth function argument
	 * @param e the fifth function argument
	 * @param f the sixth function argument
	 * @param g the seventh function argument
	 * @param h the eighth function argument
	 */
	public void accept(A a, B b, C c, D d, E e, F f, G g, H h);

	/**
	 * Returns the {@code OctaConsumer} function that first executes the current
	 * {@code OctaConsumer} instance's {@code accept} method, then executes the
	 * {@code after} parameter's {@code accept} method.
	 *
	 * @param  after the {@code OctaConsumer} instance to execute after the
	 *         current instance
	 * @return the {@code OctaConsumer} that executes the current instance's
	 *         {@code accept} method, as well as that of {@code after}
	 */
	public default OctaConsumer<A, B, C, D, E, F, G, H> andThen(
		OctaConsumer<? super A, ? super B, ? super C, ? super D, ? super E,
			? super F, ? super G, ? super H> after) {

		Objects.requireNonNull(after);

		return (a, b, c, d, e, f, g, h) -> {
			accept(a, b, c, d, e, f, g, h);
			after.accept(a, b, c, d, e, f, g, h);
		};
	}

}