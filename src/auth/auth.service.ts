import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { User, AuthProvider } from '../users/entities/user.entity';
import { RegisterDto } from './dto/register.dto';

interface OAuthUserData {
  email: string;
  name: string;
  profilePicture?: string;
  provider: string;
  providerId: string;
}

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async validateUser(email: string, password: string): Promise<any> {
    const user = await this.usersService.findByEmail(email);
    
    if (!user || !user.password) {
      return null;
    }

    const isPasswordValid = await this.usersService.validatePassword(
      password,
      user.password,
    );

    if (!isPasswordValid) {
      return null;
    }

    if (!user.isActive) {
      throw new UnauthorizedException('Account is deactivated');
    }

    const { password: _, ...result } = user;
    return result;
  }

  async validateOAuthUser(userData: OAuthUserData): Promise<User> {
    const { email, name, profilePicture, provider, providerId } = userData;
    
    let user = await this.usersService.findByProviderData(
      provider as AuthProvider,
      providerId,
    );

    if (user) {
      await this.usersService.updateLastLogin(user.id);
      return user;
    }

    user = await this.usersService.findByEmail(email);
    
    if (user) {
      throw new ConflictException(
        'An account with this email already exists. Please sign in with your password.',
      );
    }

    user = await this.usersService.create({
      email,
      name,
      profilePicture,
      authProvider: provider as AuthProvider,
      providerId,
    });

    return user;
  }

  async register(registerDto: RegisterDto): Promise<{ user: Partial<User>; access_token: string }> {
    const user = await this.usersService.create(registerDto);
    const { password, ...userWithoutPassword } = user;
    
    const payload = { email: user.email, sub: user.id };
    const access_token = this.jwtService.sign(payload);

    return {
      user: userWithoutPassword,
      access_token,
    };
  }

  async login(user: User): Promise<{ user: Partial<User>; access_token: string }> {
    await this.usersService.updateLastLogin(user.id);
    
    const payload = { email: user.email, sub: user.id };
    const access_token = this.jwtService.sign(payload);

    const { password, ...userWithoutPassword } = user;

    return {
      user: userWithoutPassword,
      access_token,
    };
  }

  async getProfile(userId: string): Promise<User> {
    return this.usersService.findById(userId);
  }
}